# TODO: DRY this with questions_controller_spec.rb
RSpec.describe QuizQuestionsController do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }
  let(:answer) { question.answers.first }
  let(:another_question) { create(:question) }
  let(:another_answer) { another_question.answers.first }

  describe "GET show" do
    context "when question number is not specified" do
      before :each do
        get :show, quiz_id: quiz.slug
      end

      it "assigns question numbers" do
        expect(assigns(:question_number)).to eq 1
        expect(assigns(:question_index)).to eq 0
        expect(assigns(:questions_left)).to eq quiz.questions.length
      end

      it "assigns quiz and its first question" do
        expect(assigns(:quiz)).to eq quiz
        expect(assigns(:question)).to eq quiz.questions.first
      end
    end

    context "when question number is specified" do
      before :each do
        get :show, quiz_id: quiz.slug, n: 2
      end

      it "assigns question numbers" do
        expect(assigns(:question_number)).to eq 2
        expect(assigns(:question_index)).to eq 1
        expect(assigns(:questions_left)).to eq quiz.questions.length - 1
      end

      it "assigns quiz and given question" do
        expect(assigns(:quiz)).to eq quiz
        expect(assigns(:question)).to eq quiz.questions[1]
      end
    end

    it "redirects to results if question answered" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: answer.id
      get :show, quiz_id: quiz.slug

      expect(response).to redirect_to action: :results, quiz_id: quiz.slug, n: 1
    end
  end

  describe "POST vote" do
    it "increments answer's votes" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "allows only one vote" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: answer.id
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "checks if the answer belongs to the question" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: another_answer.id
      another_answer.reload
      expect(another_answer.votes).to eq 0
    end

    # following not DRYable?
    it "redirects to proper results page" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: answer.id

      expect(response).to redirect_to action: :results, quiz_id: quiz.slug, n: 1
    end

    it "increments correct answers for quiz in session if answer is correct" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: question.answers.correct.id

      expect(session[:quizzes][quiz.id][:correct_count]).to eq 1
    end

    it "doesn't increment correct answers for quiz if question already voted on" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: question.answers.wrong.first.id
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: question.answers.correct.id

      expect(session[:quizzes][quiz.id][:correct_count]).to eq 0
    end
  end

  describe "GET results" do
    it "redirects to the question if no vote made" do
      get :results, quiz_id: quiz.slug, n: 1
      expect(response).to redirect_to action: :show
    end

    context "when vote made" do
      before :each do
        session[:voted] = { question.id => answer.id }
      end

      it "assigns question numbers" do
        get :results, quiz_id: quiz.slug, n: 1
        expect(assigns(:question_number)).to eq 1
        expect(assigns(:question_index)).to eq 0
        expect(assigns(:questions_left)).to eq quiz.questions.length - 1
      end

      it "shows results if vote made" do
        get :results, quiz_id: quiz.slug, n: 1
        expect(subject).to render_template 'results'
      end

      it "marks selected answer" do
        get :results, quiz_id: quiz.slug, n: 1
        expect(assigns[:vote_answer_id]).to eq answer.id
      end

      it "assigns link to next question" do
        get :results, quiz_id: quiz.slug, n: 1
        expect(assigns[:next_label]).to eq "Next question"
        expect(assigns[:next_path]).to eq quiz_question_path(quiz, 2)
      end

      it "assigns link to quiz results if it's the last question" do
        get :results, quiz_id: quiz.slug, n: quiz.questions.count
        expect(assigns[:next_label]).to eq "Done"
        expect(assigns[:next_path]).to eq quiz_results_path(quiz)
      end
    end
  end

  describe "GET quiz_results" do
    it "assigns score" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: quiz.questions[0].answers.wrong.first.id
      post :vote, quiz_id: quiz.slug, n: 2, answer_id: quiz.questions[1].answers.correct.id
      get :quiz_results, quiz_id: quiz.slug

      expect(assigns[:score]).to eq 50
    end

    it "redirects to the quiz if all questions not answered" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: quiz.questions[0].answers.wrong.first.id
      get :quiz_results, quiz_id: quiz.slug

      expect(response).to redirect_to action: :show
    end
  end
end

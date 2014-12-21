# TODO: DRY this with questions_controller_spec.rb
RSpec.shared_examples "questions controller" do
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
        expect(assigns(:questions_count)).to eq quiz.questions.length
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
        expect(assigns(:questions_count)).to eq quiz.questions.length
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

    it "doesn't register score if quiz not finished" do
      expect_any_instance_of(Quiz).not_to receive(:register_score!)

      post :vote, quiz_id: quiz.slug, n: 1, answer_id: question.answers.correct.id
    end

    context "when voting on the last question" do
      before :each do
        post :vote, quiz_id: quiz.slug, n: 1, answer_id: quiz.questions[0].answers.wrong.first.id
      end

      it "updaes quiz's average_score" do
        expect {
          post :vote, quiz_id: quiz.slug, n: 2, answer_id: quiz.questions[1].answers.correct.id
          quiz.reload
        }.to change { quiz.average_score }
      end

      it "updaes quiz's times_taken" do
        expect {
          post :vote, quiz_id: quiz.slug, n: 2, answer_id: quiz.questions[1].answers.correct.id
          quiz.reload
        }.to change { quiz.times_taken }
      end
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
        expect(assigns[:next_path]).to eq path_to_next_question
      end

      it "assigns link to quiz results if it's the last question" do
        get :results, quiz_id: quiz.slug, n: quiz.questions.count
        expect(assigns[:next_label]).to eq "Done"
        expect(assigns[:next_path]).to eq path_to_quiz_results
      end
    end
  end

  describe "GET quiz_results" do
    context "when all questions answered" do
      before :each do
        post :vote, quiz_id: quiz.slug, n: 1, answer_id: quiz.questions[0].answers.wrong.first.id
        post :vote, quiz_id: quiz.slug, n: 2, answer_id: quiz.questions[1].answers.correct.id
        quiz.reload
      end

      it "assigns score" do
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:score]).to eq 50
      end

      it "assigns average_score" do
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:average_score]).to eq quiz.average_score.round
      end

      # TODO: This is crap, refactor those specs as a part of #24 to avoid stubbing
      # a private method
      it "assigns below average how_wrong if score lower than average_score by > 5% points" do
        allow(controller).to receive(:get_score).and_return(quiz.average_score - 6)
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:how_wrong]).to eq "You're way below average"
      end

      it "assigns below average how_wrong if score within 5% points of average_score" do
        allow(controller).to receive(:get_score).and_return(quiz.average_score - 3)
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:how_wrong]).to eq "You're average"
      end

      it "assigns above average how_wrong if score higher than average_score by > 5% points" do
        allow(controller).to receive(:get_score).and_return(quiz.average_score + 6)
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:how_wrong]).to eq "You're better than average"
      end
    end

    it "redirects to the quiz if all questions not answered" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: quiz.questions[0].answers.wrong.first.id
      get :quiz_results, quiz_id: quiz.slug

      expect(response).to redirect_to action: :show
    end
  end
end

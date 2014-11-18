# TODO: DRY this with questions_controller_spec.rb
RSpec.describe QuizQuestionsController do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }
  let(:answer) { question.answers.first }
  let(:another_question) { create(:question) }
  let(:another_answer) { another_question.answers.first }

  describe "GET show" do
    it "assigns quiz and its first question if question id not present" do
      get :show, quiz_id: quiz.slug

      expect(assigns(:quiz)).to eq quiz
      expect(assigns(:question)).to eq quiz.questions.first
    end

    it "assigns quiz and given question if question number present" do
      get :show, quiz_id: quiz.slug, n: 2

      expect(assigns(:quiz)).to eq quiz
      expect(assigns(:question)).to eq quiz.questions[1]
    end

    it "redirects to results if question answered" do
      session[:voted] = { question.id => answer.id }
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

    # this one not DRYable?
    it "redirects to proper results page" do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: answer.id

      expect(response).to redirect_to action: :results, quiz_id: quiz.slug, n: 1
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
end

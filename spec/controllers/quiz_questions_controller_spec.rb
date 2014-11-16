# TODO: DRY this with questions_controller_spec.rb
RSpec.describe QuizQuestionsController do
  let(:quiz) { create(:quiz) }

  describe "GET show" do
    it "assigns quiz and its first question if question id not present" do
      get :show, quiz_id: quiz.slug

      expect(assigns(:quiz)).to eq quiz
      expect(assigns(:question)).to eq quiz.questions.first
    end

    it "assigns quiz and given question if question id present" do
      get :show, quiz_id: quiz.slug, id: quiz.questions.last.slug

      expect(assigns(:quiz)).to eq quiz
      expect(assigns(:question)).to eq quiz.questions.last
    end
  end

  describe "POST vote", focus:true do
    let(:question) { quiz.questions.first }
    let(:answer) { question.answers.first }
    let(:another_question) { create(:question) }
    let(:another_answer) { another_question.answers.first }

    it "increments answer's votes" do
      post :vote, quiz_id: quiz.slug, id: question.slug, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "allows only one vote" do
      post :vote, quiz_id: quiz.slug, id: question.slug, answer_id: answer.id
      post :vote, quiz_id: quiz.slug, id: question.slug, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "blocks votes for different questions independently" do
      post :vote, quiz_id: quiz.slug, id: question.slug, answer_id: answer.id
      post :vote, quiz_id: quiz.slug, id: another_question.slug, answer_id: another_answer.id
      answer.reload
      another_answer.reload
      expect(answer.votes).to eq 1
      expect(another_answer.votes).to eq 1
    end

    it "checks if the answer belongs to the question" do
      post :vote, quiz_id: quiz.slug, id: question.slug, answer_id: another_answer.id
      another_answer.reload
      expect(another_answer.votes).to eq 0
    end

    # this one not DRYable?
    it "redirects to proper results page" do
      post :vote, quiz_id: quiz.slug, id: question.slug, answer_id: answer.id

      expect(response).to redirect_to action: :results, quiz_id: quiz.slug, id: question.slug
    end
  end
end

RSpec.describe QuizQuestionsController do
  describe "GET show" do
    let(:quiz) { create(:quiz) }

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
end

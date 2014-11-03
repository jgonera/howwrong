RSpec.describe QuizzesController do
  describe "GET show" do
    it "assigns @quiz and @question" do
      quiz = build(:quiz)
      expect(Quiz).to receive_message_chain(:friendly, :find).with("test").and_return(quiz)

      get :show, id: "test"

      expect(assigns(:quiz)).to eq quiz
      expect(assigns(:question)).to eq quiz.questions.first
    end
  end
end

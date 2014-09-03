require 'spec_helper'

describe QuizzesController do
  describe "GET show" do
    it "assigns @quiz" do
      quiz = build_stubbed(:quiz)
      expect(Quiz).to receive_message_chain(:friendly, :find).with("test").and_return(quiz)

      get :show, id: "test"

      expect(assigns(:quiz)).to eq quiz
    end
  end
end

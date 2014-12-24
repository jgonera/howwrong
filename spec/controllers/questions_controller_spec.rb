require "rails_helper"
require "controllers/shared_examples/shared_examples_for_questions_controller"

RSpec.describe QuestionsController do
  let(:question) { create :question }
  let(:answer) { question.answers.first }
  let(:another_question) { create :question }
  let(:another_answer) { another_question.answers.first }
  # used by "questions controller" examples
  let(:params) { { id: question.slug } }
  let(:another_params) { { id: another_question.slug } }

  include_examples "questions controller"

  describe "GET show" do
    it "assigns other question" do
      # Force creating another question
      another_question
      get :show, id: question.slug
      expect(assigns[:other_questions].length).to eq 1
      expect(assigns[:other_questions][0]).to eq another_question
    end
  end

  describe "GET short" do
    it "redirects to canonical URL" do
      get :short, id: question.id
      expect(response).to redirect_to action: :show, id: question.slug
    end
  end
end

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

  describe "POST create" do
    let(:params) do
      {
        question: {
          text: "Do I like marshmellows?",
          source: "Old wisdom",
          source_url: "http://localhost",
        },
        answers: [
          "Yes",
          "No",
          "",
        ],
        correct_answer: 1,
      }
    end

    it "creates a question and answers" do
      expect {
        post :create, params
      }.to change { Question.count }.by(1)

      question = Question.first

      expect(question.text).to eql(params[:question][:text])
      expect(question.source).to eql(params[:question][:source])
      expect(question.source_url).to eql(params[:question][:source_url])
      expect(question.answers.length).to eql(2)
      expect(question.answers[0].label).to eql(params[:answers][0])
      expect(question.answers[1].label).to eql(params[:answers][1])
      expect(question.answers[1].is_correct).to eql(true)
    end

    it "redirects to question" do
      post :create, params

      expect(response).to redirect_to(question_path(Question.first))
    end
  end
end

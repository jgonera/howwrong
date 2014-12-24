require "rails_helper"
require "controllers/shared_examples/shared_examples_for_questions_controller"
require "controllers/shared_examples/shared_examples_for_quiz_questions_controller"

RSpec.describe EmbeddedQuizQuestionsController do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }
  let(:another_question) { quiz.questions.last }
  let(:path_to_next_question) { embedded_quiz_question_path(quiz, 2) }
  let(:path_to_quiz_results) { embedded_quiz_results_path(quiz) }
  # used by "questions controller" examples
  let(:params) { { quiz_id: quiz.slug, n: 1 } }
  let(:another_params) { { quiz_id: quiz.slug, n: 2 } }

  include_examples "questions controller"
  include_examples "quiz questions controller"

  shared_examples_for "embedded layout" do
    it "uses embedded layout" do
      expect(response).to render_template("layouts/embedded")
      expect(response).not_to render_template("layouts/application")
    end
  end

  describe "GET show" do
    before :each do
      get :show, quiz_id: quiz.slug
    end

    include_examples "embedded layout"
  end

  describe "GET results" do
    before :each do
      session[:voted] = { question.id => answer.id }
      get :results, params
    end

    include_examples "embedded layout"
  end

  describe "GET quiz_results" do
    before :each do
      post :vote, params.merge(answer_id: question.answers.wrong.first.id)
      post :vote, another_params.merge(answer_id: another_question.answers.correct.id)
      get :quiz_results, quiz_id: quiz.slug
    end

    include_examples "embedded layout"
  end
end

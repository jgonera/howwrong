require "controllers/shared_examples/shared_examples_for_questions_controller"

RSpec.describe EmbeddedQuizQuestionsController do
  let(:quiz) { create(:quiz) }
  let(:path_to_next_question) { embedded_quiz_question_path(quiz, 2) }
  let(:path_to_quiz_results) { embedded_quiz_results_path(quiz) }

  include_examples "questions controller"

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
      get :results, quiz_id: quiz.slug, n: 1
    end

    include_examples "embedded layout"
  end

  describe "GET quiz_results" do
    before :each do
      post :vote, quiz_id: quiz.slug, n: 1, answer_id: quiz.questions[0].answers.wrong.first.id
      post :vote, quiz_id: quiz.slug, n: 2, answer_id: quiz.questions[1].answers.correct.id
      get :quiz_results, quiz_id: quiz.slug
    end

    include_examples "embedded layout"
  end
end

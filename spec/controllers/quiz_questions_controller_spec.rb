require "rails_helper"
require "controllers/shared_examples/shared_examples_for_questions_controller"
require "controllers/shared_examples/shared_examples_for_quiz_questions_controller"

RSpec.describe QuizQuestionsController do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }
  let(:another_question) { quiz.questions.last }
  let(:path_to_next_question) { quiz_question_path(quiz, 2) }
  let(:path_to_quiz_results) { quiz_results_path(quiz) }
  # used by "questions controller" examples
  let(:params) { { quiz_id: quiz.slug, n: 1 } }
  let(:another_params) { { quiz_id: quiz.slug, n: 2 } }

  include_examples "questions controller"
  include_examples "quiz questions controller"
end

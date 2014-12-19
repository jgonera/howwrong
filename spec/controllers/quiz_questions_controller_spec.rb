require "rails_helper"
require "controllers/shared_examples/shared_examples_for_questions_controller"

RSpec.describe QuizQuestionsController do
  let(:quiz) { create(:quiz) }
  let(:path_to_next_question) { quiz_question_path(quiz, 2) }
  let(:path_to_quiz_results) { quiz_results_path(quiz) }

  include_examples "questions controller"
end

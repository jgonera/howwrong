require "controllers/shared_examples/shared_examples_for_questions_controller"

RSpec.describe EmbeddedQuizQuestionsController do
  let(:quiz) { create(:quiz) }
  let(:path_to_next_question) { embedded_quiz_question_path(quiz, 2) }
  let(:path_to_quiz_results) { embedded_quiz_results_path(quiz) }

  include_examples "questions controller"
end

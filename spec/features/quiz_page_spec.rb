require "features/shared_examples/shared_examples_for_quiz"

RSpec.describe "quiz page" do
  let(:quiz) { create(:quiz) }
  let(:path_to_next_question) { quiz_question_path(quiz, 2) }
  let(:path_to_quiz_results) { quiz_results_path(quiz) }

  before :each do
    visit quiz_path(quiz)
  end

  include_examples "quiz"
end

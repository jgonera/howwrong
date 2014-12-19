require "rails_helper"
require "features/shared_examples/shared_examples_for_quiz"

RSpec.describe "embedded quiz" do
  let(:quiz) { create(:quiz) }
  let(:path_to_next_question) { embedded_quiz_question_path(quiz, 2) }
  let(:path_to_quiz_results) { embedded_quiz_results_path(quiz) }

  before :each do
    visit embedded_quiz_path(quiz)
  end

  include_examples "quiz"
end

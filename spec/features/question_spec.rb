require "rails_helper"
require "features/shared_examples/shared_examples_for_question"

RSpec.describe "question" do
  include_examples "question" do
    let!(:question) { create :question }

    before :each do
      visit question_path(question)
    end
  end
end

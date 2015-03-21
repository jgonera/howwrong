require "rails_helper"
require "features/shared_examples/shared_examples_for_question"

RSpec.describe "question" do
  include_examples "question" do
    let(:question) { create :question }

    before :each do
      visit question_path(question)
    end
  end

  it "displays other questions" do
    expect(page).to have_selector 'li', text: another_question.text
    expect(page).to_not have_selector 'li', text: question.text
  end
end

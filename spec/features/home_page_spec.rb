require 'spec_helper'

describe "home page" do
  let!(:question) { create :question, text: "Are you wrong?" }
  let!(:wrong_answer) { create :answer, question: question }
  let!(:featured_question) { create :question, text: "Are you featured 1?", is_featured: true }
  let(:featured_answer) { featured_question.answers.first }

  before :each do
    visit '/'
  end

  it "displays the latest featured question, its answers and source" do
    expect(page).to have_selector 'h1', text: featured_question.text
    featured_question.answers.each { |answer| expect(page).to have_content answer.label }
    expect(page).to_not have_content wrong_answer.label
  end

  context "when there are more featured questions" do
    let!(:another_featured_question) { create :question, text: "Are you featured 2?", is_featured: true }
    let(:another_featured_answer) { another_featured_question.answers.first }

    it "replaces featured question with a different one" do
      choose featured_answer.label
      click_button "Submit"
      visit '/'
      expect(page).to have_selector 'h1', text: another_featured_question.text
    end
  end
end

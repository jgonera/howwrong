require 'spec_helper'

describe "home page" do
  let!(:question) { create :question, text: "Are you wrong?" }
  let!(:wrong_answer) { create :answer, question: question }
  let!(:another_question) { create :question, text: "Whats your favourite website?" }
  let!(:featured_question) { create :question, text: "Are you featured 1?", is_featured: true }
  let(:featured_answer) { featured_question.answers.first }

  before :each do
    visit '/'
  end

  it "displays the latest featured question, its answers and source" do
    expect(page).to have_selector 'h2', text: featured_question.text
    featured_question.answers.each { |answer| expect(page).to have_content answer.label }
    expect(page).to_not have_content wrong_answer.label
  end

  it "allows voting" do
    choose featured_answer.label
    click_button "Submit"
    featured_answer.reload
    expect(featured_answer.votes).to eq 1
  end

  it "allows single click voting if JavaScript enabled", js: true do
    find('label', text: featured_answer.label.upcase).click
    featured_answer.reload
    expect(featured_answer.votes).to eq 1
  end

  it "marks selected answer in results" do
    choose featured_answer.label
    click_button "Submit"
    answer_row = page.find 'tr', text: featured_answer.label
    expect(page).to have_selector 'tr.vote', text: featured_answer.label
  end

  it "gives feedback in results" do
    choose featured_answer.label
    click_button "Submit"
    expect(page).to have_selector 'dd', text: featured_answer.feedback.text
  end

  it "displays other questions" do
    expect(page).to have_selector 'li', text: question.text
    expect(page).to have_selector 'li', text: another_question.text
    expect(page).to_not have_selector 'li', text: featured_question.text
  end

  context "when there are more featured questions" do
    let!(:another_featured_question) { create :question, text: "Are you featured 2?", is_featured: true }
    let(:another_featured_answer) { another_featured_question.answers.first }

    it "replaces featured question with a different one" do
      choose featured_answer.label
      click_button "Submit"
      visit '/'
      expect(page).to have_selector 'h2', text: another_featured_question.text
    end
  end
end

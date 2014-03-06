require 'spec_helper'

describe "home page" do
  let!(:wrong_question) { create :question, text: "Are you wrong?" }
  let!(:wrong_answer) { create :answer, question: wrong_question }
  let!(:question) { create :question }
  let(:answer) { question.answers.first }

  before :each do
    visit '/'
  end

  it "displays only the latest question, its answers and source" do
    expect(page).to have_content question.text
    question.answers.each { |answer| expect(page).to have_content answer.label }
    expect(page).to_not have_content wrong_question.text
    expect(page).to_not have_content wrong_answer.label
  end

  it "allows voting" do
    choose answer.label
    click_button "Submit"
    answer.reload
    expect(answer.votes).to eq 1
  end

  it "allows single click voting if JavaScript enabled", js: true do
    choose answer.label
    answer.reload
    expect(answer.votes).to eq 1
  end

  it "marks selected answer in results" do
    choose answer.label
    click_button "Submit"
    answer_row = page.find 'tr', text: answer.label
    expect(page).to have_selector 'tr.vote', text: answer.label
  end
end

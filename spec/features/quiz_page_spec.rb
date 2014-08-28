require "spec_helper"

describe "quiz page", wip: true do
  let!(:question_1) { create :question, text: "Question 1" }
  let!(:question_2) { create :question, text: "Question 2" }
  let!(:quiz) { create :quiz, questions: [question_1, question_2] }

  before :each do
    visit quiz_path(quiz)
  end

  it "shows the first question" do
    expect(page).to have_selector "h1", text: question_1.text
    question_1.answers.each { |answer| expect(page).to have_content answer.label }
  end

  it "doesn't show other questions" do
    expect(page).to_not have_content question_2.label
  end
end

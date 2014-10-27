require "spec_helper"

describe "quiz page" do
  let!(:quiz) { create :quiz }

  before :each do
    visit quiz_path(quiz)
  end

  it "shows the first question" do
    expect(page).to have_selector "h1", text: quiz.questions.first.text
    quiz.questions.first.answers.each do |answer|
      expect(page).to have_content answer.label
    end
  end

  it "doesn't show other questions" do
    expect(page).to_not have_content quiz.questions[1].text
  end
end

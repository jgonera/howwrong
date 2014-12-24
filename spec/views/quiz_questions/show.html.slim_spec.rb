require "rails_helper"

RSpec.describe "quiz_questions/show.html.slim" do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }
  let(:question_number) { 1 }
  let(:questions_left) { 2 }
  let(:questions_count) { 2 }

  before :each do
    assign :quiz, quiz
    assign :question, question
    assign :question_number, question_number
    assign :questions_left, questions_left
    assign :questions_count, questions_count
    render
  end

  it "shows question text" do
    expect(rendered).to have_content question.text
  end

  it "renders form with correct link" do
    expect(rendered).
      to have_selector "form[action='#{path_for(action: "vote", quiz_id: quiz, n: question_number)}']"
  end

  it "shows how many questions are left" do
    expect(view.content_for(:nav)).to have_content "#{questions_left} questions left"
  end
end

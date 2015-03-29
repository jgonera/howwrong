require "rails_helper"

RSpec.describe "quiz_questions/results.html.slim" do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }
  let(:questions_left) { 1 }
  let(:questions_count) { 2 }

  before :each do
    assign :quiz, quiz
    assign :question, question
    assign :vote_answer_id, question.answers.first.id
    assign :next_path, "/test"
    assign :next_label, "Test"
    assign :questions_left, questions_left
    assign :questions_count, questions_count
    assign :progress_label, "Test label"
    render
  end

  it "renders form with correct next button" do
    expect(rendered).to have_link "Test", href: "/test"
  end

  it "shows how many questions are left" do
    expect(view.content_for(:nav)).to have_content "#{questions_left} question left"
  end

  context "when no questions left" do
    let(:questions_left) { 0 }

    it "doesn't say 0 questions left" do
      expect(view.content_for(:nav)).not_to have_content "0 questions left"
    end

    it "shows a link to quiz results" do
      expect(view.content_for(:nav)).to have_link "Test label", href: "/test"
    end
  end
end

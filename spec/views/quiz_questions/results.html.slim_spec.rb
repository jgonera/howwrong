RSpec.describe "quiz_questions/results.html.slim" do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }

  it "renders form with correct next button" do
    assign :quiz, quiz
    assign :question, question
    assign :vote_answer_id, question.answers.first
    assign :next_path, "/test"
    assign :next_label, "Test"

    render
    expect(rendered).to have_link "Test", href: "/test"
  end
end

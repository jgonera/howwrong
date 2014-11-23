RSpec.describe "quiz_questions/results.html.slim" do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }
  let(:questions_left) { 1 }

  before :each do
    assign :quiz, quiz
    assign :question, question
    assign :vote_answer_id, question.answers.first
    assign :next_path, "/test"
    assign :next_label, "Test"
    assign :questions_left, questions_left
    render
  end

  it "renders form with correct next button" do
    expect(rendered).to have_link "Test", href: "/test"
  end

  it "shows how many questions are left" do
    expect(rendered).to have_content "#{questions_left} question left"
  end
end

RSpec.describe "quizzes/show.html.slim" do
  let(:quiz) { create(:quiz) }
  let(:question) { quiz.questions.first }

  it "renders form with correct link" do
    assign :quiz, quiz
    assign :question, question

    render
    expect(rendered).to have_selector "form[action='#{vote_quiz_question_path(quiz, question)}']"
  end
end

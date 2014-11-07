require "features/shared_examples/shared_examples_for_results_page"

RSpec.describe "quiz page" do
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

  context "when vote submitted", focus:true do
    let(:answer) { quiz.questions.first.answers.first }

    it_behaves_like "results page"

    it "shows a link to quiz's next question" do
      expect(page).to have_link "Next question", href: quiz_question_path(quiz, quiz.questions[1])
    end
  end
end

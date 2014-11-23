require "features/shared_examples/shared_examples_for_results_page"

RSpec.describe "quiz page" do
  let(:quiz) { create :quiz }

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

  it "shows how many questions are left" do
    expect(page).to have_content "2 questions left"
  end

  context "when vote is submitted" do
    let(:answer) { quiz.questions.first.answers.first }

    before :each do
      choose answer.label
      click_button "Submit"
    end

    it_behaves_like "results page"

    it "shows a link to quiz's next question" do
      expect(page).to have_link "Next question", href: quiz_question_path(quiz, 2)
    end

    it "shows how many questions are left" do
      expect(page).to have_content "1 question left"
    end
  end

  context "when last question is answered" do
    before :each do
      choose quiz.questions[0].answers.first.label
      click_button "Submit"
      click_link "Next question"
      choose quiz.questions[1].answers.last.label
      click_button "Submit"
    end

    it "shows a link to quiz results" do
      expect(page).to have_link "Done", href: quiz_results_path(quiz)
    end

    context "when viewing quiz results" do
      before :each do
        click_link "Done"
      end

      it "says that the quiz is completed" do
        expect(page).to have_content "Quiz completed"
      end
    end
  end
end

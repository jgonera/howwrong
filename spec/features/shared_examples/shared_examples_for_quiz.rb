require "features/shared_examples/shared_examples_for_results_page"

RSpec.shared_examples "quiz" do
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
      expect(page).to have_link "Next question", href: path_to_next_question
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
      expect(page).to have_link "Done", href: path_to_quiz_results
    end

    context "when viewing quiz results" do
      before :each do
        click_link "Done"
      end

      it "says that the quiz is completed" do
        expect(page).to have_content "Quiz completed"
      end

      it "shows score" do
        expect(page).to have_content "Your score 50%"
      end

      it "shows average score" do
        average_score = (quiz.times_taken * quiz.average_score + 50) / (quiz.times_taken + 1)
        expect(page).to have_content "Average score #{average_score.round}%"
      end

      it "shows how wrong the user is" do
        expect(page).to have_content "How wrong? You're way below average"
      end
    end
  end
end

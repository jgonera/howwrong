require "features/shared_examples/shared_examples_for_results"

RSpec.shared_examples "quiz" do
  it "shows the first question" do
    expect(page).to have_content quiz.questions.first.text
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

    include_examples "results"

    it "shows a link to quiz's next question" do
      expect(page).to have_link "Next", href: path_to_next_question
    end

    it "shows how many questions are left" do
      expect(page).to have_content "1 question left"
    end
  end

  context "when last question is answered" do
    before :each do
      choose quiz.questions[0].answers.first.label
      click_button "Submit"
      click_link "Next"
      choose quiz.questions[1].answers.last.label
      click_button "Submit"
    end

    it "shows a link to quiz results" do
      expect(page).to have_link "Done", href: path_to_quiz_results
    end

    context "when viewing quiz results" do
      it "says that the quiz is completed" do
        click_link "Done"

        expect(page).to have_content "Quiz completed"
      end

      it "shows score" do
        click_link "Done"

        expect(page).to have_content "Your score50%"
      end

      it "shows average score" do
        click_link "Done"

        average_score = (quiz.times_taken * quiz.average_score + 50) / (quiz.times_taken + 1)
        expect(page).to have_content "Average score#{average_score.round}%"
      end

      it "shows how wrong the user is" do
        click_link "Done"

        expect(page).to have_content "How wrong?You're way below average"
      end

      context "when there are other quizzes" do
        let!(:other_quizzes) do
          [
            create(:quiz),
            create(:quiz),
            create(:quiz),
          ]
        end

        it "shows other quizzes in the footer", focus: true do
          click_link "Done"

          expect(page).to have_content other_quizzes[0].title
          expect(page).to have_content other_quizzes[1].title
          expect(page).to have_content other_quizzes[2].title
        end
      end
    end
  end
end

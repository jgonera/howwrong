require 'spec_helper'

describe "home page" do
  it "displays only the latest question" do
    Question.create text: "Are you wrong?"
    Question.create text: "Are you tested?"
    visit '/'
    expect(page).to have_content "Are you tested?"
    expect(page).to_not have_content "Are you wrong?"
  end

  context "when question has answers" do
    let(:answers) { ["Yes", "No", "Maybe"] }
    before :each do
      @question = Question.create text: "Are you tested?"
      answers.each { |answer| @question.answers.create label: answer }
    end

    it "displays answers" do
      visit '/'
      answers.each { |answer| expect(page).to have_content answer }
    end

    context "when vote is cast" do
      before :each do
        visit '/'
        choose "Maybe"
        click_button "Submit"
      end

      it "allows increases votes for answer" do
        votes = @question.answers.find_by(label: "Maybe").votes
        expect(votes).to eq 1
      end

      it "shows results" do
        expect(page).to have_content "Yes0"
        expect(page).to have_content "No0"
        expect(page).to have_content "Maybe1"
      end
    end
  end
end

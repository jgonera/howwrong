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

    it "allows voting" do
      visit '/'
      choose "Maybe"
      click_button "Submit"
      votes = @question.answers.find_by(label: "Maybe").votes
      expect(votes).to eq 1
    end
  end

end

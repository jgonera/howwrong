require "features/shared_examples/shared_examples_for_results"

RSpec.shared_examples "question" do
  let(:answer) { question.answers.first }
  let!(:another_question) { create :question }

  it "allows single click voting if JavaScript enabled", js: true do
    find('label', text: answer.label.upcase).click
    answer.reload
    expect(answer.votes).to eq 1
  end

  context "when vote submitted" do
    before :each do
      choose answer.label
      click_button "Submit"
    end

    include_examples "results"

    it "gives feedback in results" do
      expect(page).to have_selector 'dd', text: answer.feedback.text
    end
  end
end

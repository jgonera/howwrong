require "features/shared_examples/shared_examples_for_results_page"

RSpec.shared_examples "question page" do
  let(:answer) { question.answers.first }
  let!(:another_question) { create :question }

  it "allows single click voting if JavaScript enabled", js: true do
    find('label', text: answer.label.upcase).click
    answer.reload
    expect(answer.votes).to eq 1
  end

  it "displays other questions" do
    expect(page).to have_selector 'li', text: another_question.text
    expect(page).to_not have_selector 'li', text: question.text
  end

  context "when vote submitted" do
    it_behaves_like "results page"
  end
end
RSpec.shared_examples "question page" do
  let(:answer) { question.answers.first }
  let!(:another_question) { create :question }

  it "allows voting" do
    choose answer.label
    click_button "Submit"
    answer.reload
    expect(answer.votes).to eq 1
  end

  it "allows single click voting if JavaScript enabled", js: true do
    find('label', text: answer.label.upcase).click
    answer.reload
    expect(answer.votes).to eq 1
  end

  it "marks selected answer in results" do
    choose answer.label
    click_button "Submit"
    expect(page).to have_selector 'tr.vote', text: answer.label
  end

  it "gives feedback in results" do
    choose answer.label
    click_button "Submit"
    expect(page).to have_selector 'dd', text: answer.feedback.text
  end

  it "displays other questions" do
    expect(page).to have_selector 'li', text: another_question.text
    expect(page).to_not have_selector 'li', text: question.text
  end
end



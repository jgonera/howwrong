RSpec.shared_examples "results page" do
  before :each do
    choose answer.label
    click_button "Submit"
  end

  it "increments answer's vote count" do
    answer.reload
    expect(answer.votes).to eq 1
  end

  it "marks selected answer in results" do
    expect(page).to have_selector 'tr.vote', text: answer.label
  end

  it "gives feedback in results" do
    expect(page).to have_selector 'dd', text: answer.feedback.text
  end
end

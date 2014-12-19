RSpec.shared_examples "results" do
  it "increments answer's vote count" do
    answer.reload
    expect(answer.votes).to eq 1
  end

  it "marks selected answer in results" do
    expect(page).to have_selector 'tr.vote', text: answer.label
  end
end

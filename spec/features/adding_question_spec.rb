RSpec.describe "adding question", focus:true do
  let(:text) { "Do I like marshmellows?" }
  let(:answer_1) { "Yes" }
  let(:answer_2) { "No" }
  let(:source) { "Old wisdom" }
  let(:source_url) { "http://localhost" }

  it "adds a new question and shows it" do
    visit "/question/new"

    fill_in "Enter a question", with: text

    fill_in "Answer #1", with: answer_1
    fill_in "Answer #2", with: answer_2

    choose "Answer #2"

    fill_in "What is the source for the correct answer?", with: source
    fill_in "What is the URL of the source for the correct answer?", with: source_url

    click_button "Done"

    expect(page).not_to have_content "Enter a question"
    expect(page).to have_content text
  end
end

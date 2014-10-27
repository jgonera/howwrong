describe "home page" do
  let!(:question) { create :question }
  let!(:featured_question) { create :question, :featured }

  before :each do
    visit '/'
  end

  it "displays the latest featured question, its answers and source" do
    expect(page).to have_selector 'h1', text: featured_question.text
    featured_question.answers.each { |answer| expect(page).to have_content answer.label }
  end

  it "doesn't display other question's answers" do
    expect(page).to_not have_content question.answers.first
  end

  context "when there are more featured questions" do
    let!(:another_featured_question) { create :question, :featured }

    it "replaces featured question with a different one after voting" do
      choose featured_question.answers.first.label
      click_button "Submit"
      visit '/'
      expect(page).to have_selector 'h1', text: another_featured_question.text
    end
  end
end

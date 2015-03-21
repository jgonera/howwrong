RSpec.shared_examples_for "standalone question" do
  it "displays other questions" do
    expect(page).to have_selector 'li', text: another_question.text
    expect(page).to_not have_selector 'li', text: question.text
  end

  it "displays share buttons" do
    expect(page).to have_xpath "//a[contains(@href, 'twitter')]"
    expect(page).to have_xpath "//a[contains(@href, 'facebook')]"
  end
end

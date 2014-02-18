require 'spec_helper'

describe "home page" do
  it "displays only the latest question" do
    Question.create text: "Are you wrong?"
    Question.create text: "How wrong are you?"
    visit '/'
    expect(page).to have_content "How wrong are you?"
    expect(page).to_not have_content "Are you wrong?"
  end
end

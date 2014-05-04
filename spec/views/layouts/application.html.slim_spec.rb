require "spec_helper"

describe "layouts/application.html.slim" do
  let(:question) { create :question, text: "Are you wrong?" }

  it "displays next question link if there is next question" do
    assign(:next_question, question)
    render
    expect(rendered).to have_selector("a[href='#{question_path(question)}']", text: "Next question")
  end

  it "displays archive link if there is next question" do
    assign(:next_question, nil)
    render
    expect(rendered).to have_selector("a[href='/archive']", text: "Next question")
  end
end

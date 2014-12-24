require "rails_helper"

RSpec.describe "questions/show.html.slim" do
  let(:question) { create(:question) }

  before :each do
    assign :question, question
    render
  end

  it "shows question text" do
    expect(rendered).to have_content question.text
  end
end

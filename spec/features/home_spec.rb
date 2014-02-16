require 'spec_helper'

describe "home page" do
  it "fucks you" do
    visit '/'
    expect(page).to have_content 'FUCK YOU'
  end
end

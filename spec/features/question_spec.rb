require "rails_helper"
require "features/shared_examples/shared_examples_for_question"
require "features/shared_examples/shared_examples_for_standalone_question"

RSpec.describe "question" do
  let(:question) { create :question }
  let!(:another_question) { create :question }

  before :each do
    visit question_path(question)
  end

  include_examples "question"
  include_examples "standalone question"
end

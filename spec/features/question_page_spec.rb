require "features/shared_examples/shared_examples_for_question_page"

describe "question page" do
  it_behaves_like "question page" do
    let!(:question) { create :question }

    before :each do
      visit question_path(question)
    end
  end
end

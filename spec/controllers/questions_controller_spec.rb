RSpec.describe QuestionsController do
  let!(:question) { create :question }
  let(:answer) { question.answers.first }
  let!(:another_question) { create :question }
  let(:another_answer) { another_question.answers.first }

  describe "POST vote" do
    it "increments answer's votes" do
      post :vote, id: question.slug, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "allows only one vote" do
      post :vote, id: question.slug, answer_id: answer.id
      post :vote, id: question.slug, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "blocks votes for different questions independently" do
      post :vote, id: question.slug, answer_id: answer.id
      post :vote, id: another_question.slug, answer_id: another_answer.id
      answer.reload
      another_answer.reload
      expect(answer.votes).to eq 1
      expect(another_answer.votes).to eq 1
    end

    it "checks if the answer belongs to the question" do
      post :vote, id: question.slug, answer_id: another_answer.id
      another_answer.reload
      expect(another_answer.votes).to eq 0
    end
  end

  describe "GET show" do
    render_views

    it "shows question" do
      get :show, id: question.slug
      expect(response.body).to have_content question.text
    end

    it "shows other question" do
      get :show, id: question.slug
      expect(assigns[:other_questions].length).to eq 1
      expect(assigns[:other_questions][0]).to eq another_question
    end

    it "redirects to results if question answered" do
      session[:voted] = { question.id => answer.id }
      get :show, id: question.slug
      expect(response).to redirect_to action: :results, id: question.slug
    end
  end

  describe "GET results" do
    it "redirects to the question if no vote made" do
      get :results, id: question.slug
      expect(response).to redirect_to action: :show
    end

    context "when vote made" do
      before :each do
        session[:voted] = { question.id => answer.id }
      end

      it "shows results if vote made" do
        get :results, id: question.slug
        expect(subject).to render_template 'results'
      end

      it "marks selected answer" do
        get :results, id: question.slug
        expect(assigns[:vote_answer_id]).to eq answer.id
      end
    end
  end

  describe "GET short" do
    it "redirects to canonical URL" do
      get :short, id: question.id
      expect(response).to redirect_to action: :show, id: question.slug
    end
  end
end

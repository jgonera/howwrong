# Requires question, another_question and params to be defined in parent spec.

RSpec.shared_examples "questions controller" do
  let(:answer) { question.answers.first }
  let(:another_answer) { another_question.answers.first }

  describe "GET show" do
    it "redirects to results if question answered" do
      post :vote, params.merge(answer_id: answer.id)
      get :show, params

      expect(response).to redirect_to params.merge(action: :results)
    end
  end

  describe "POST vote" do
    it "increments answer's votes" do
      post :vote, params.merge(answer_id: answer.id)
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "allows only one vote" do
      post :vote, params.merge(answer_id: answer.id)
      post :vote, params.merge(answer_id: answer.id)
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "checks if the answer belongs to the question" do
      post :vote, params.merge(answer_id: another_answer.id)
      another_answer.reload
      expect(another_answer.votes).to eq 0
    end

    it "blocks repeated votes for different questions independently" do
      post :vote, params.merge(answer_id: answer.id)
      post :vote, another_params.merge(answer_id: another_answer.id)
      answer.reload
      another_answer.reload
      expect(answer.votes).to eq 1
      expect(another_answer.votes).to eq 1
    end

    it "redirects to proper results page" do
      post :vote, params.merge(answer_id: answer.id)

      expect(response).to redirect_to params.merge(action: :results)
    end
  end

  describe "GET results" do
    it "redirects to the question if no vote made" do
      get :results, params
      expect(response).to redirect_to action: :show
    end

    context "when vote made" do
      let(:vote_store) { double("VoteStore") }
      before :each do
        allow(VoteStore).to receive(:new) { vote_store }
        allow(vote_store).to receive(:answer_for).
          with(question.id) { answer.id }
        allow(vote_store).to receive(:has_answer_for?).
          with(question.id) { true }
        allow(vote_store).to receive(:voted_questions) { [question.id] }
      end

      it "shows results if vote made" do
        get :results, params
        expect(subject).to render_template 'results'
      end

      it "marks selected answer" do
        get :results, params
        expect(assigns[:vote_answer_id]).to eq answer.id
      end
    end
  end
end

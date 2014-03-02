require 'spec_helper'

describe QuestionsController do
  let(:question) { create :question }

  describe "POST vote" do
    let(:answer) { question.answers.first }
    let(:another_question) { create :question }
    let(:another_answer) { another_question.answers.first }

    it "increments answer's votes" do
      post :vote, slug: question.slug, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "allows only one vote" do
      post :vote, slug: question.slug, answer_id: answer.id
      post :vote, slug: question.slug, answer_id: answer.id
      answer.reload
      expect(answer.votes).to eq 1
    end

    it "blocks votes for different questions independently" do
      post :vote, slug: question.slug, answer_id: answer.id
      post :vote, slug: another_question.slug, answer_id: another_answer.id
      answer.reload
      another_answer.reload
      expect(answer.votes).to eq 1
      expect(another_answer.votes).to eq 1
    end

    it "checks if the answer belongs to the question" do
      post :vote, slug: question.slug, answer_id: another_answer.id
      another_answer.reload
      expect(another_answer.votes).to eq 0
    end
  end

  describe "GET show" do
    render_views

    it "shows question" do
      get :show, slug: question.slug
      expect(response.body).to have_content question.text
    end
  end

  describe "GET results" do
    it "redirects to the question if no vote made" do
      get :results, slug: question.slug
      expect(response).to redirect_to action: :show
    end

    it "shows results if vote made" do
      session[:voted] = { question.id => true }
      get :results, slug: question.slug
      expect(subject).to render_template 'results'
    end
  end
end

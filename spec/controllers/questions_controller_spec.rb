require 'spec_helper'

describe QuestionsController do
  describe "POST vote" do
    let(:question) { create :question }
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
end

require "spec_helper"
require "vote_store"

RSpec.describe Howwrong::VoteStore do
  let(:hash) { {} }
  let(:vote_store) { Howwrong::VoteStore.new(hash) }
  let(:question_id) { 1 }
  let(:answer_id) { 2 }

  describe "#vote" do
    it "stores answer id for question id" do
      vote_store.vote(question_id, answer_id)

      expect(hash[question_id]).to eql(answer_id)
    end
  end

  describe "#answer_for" do
    it "returns answer id if question answered" do
      hash[question_id] = answer_id

      expect(vote_store.answer_for(question_id)).to eql(answer_id)
    end

    it "returns nil if question not answered" do
      expect(vote_store.answer_for(question_id)).to eql(nil)
    end
  end

  describe "#has_answer_for?" do
    it "returns true if question answered" do
      hash[question_id] = answer_id

      expect(vote_store.has_answer_for?(question_id)).to eql(true)
    end

    it "returns false if question not answered" do
      expect(vote_store.has_answer_for?(question_id)).to eql(false)
    end
  end
end

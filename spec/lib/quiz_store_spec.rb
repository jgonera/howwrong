require "spec_helper"
require "quiz_store"

RSpec.describe QuizStore do
  let(:hash) { {} }
  let(:quiz) { instance_double("Quiz") }
  let(:quiz_id) { 789 }
  let(:questions) { double("questions", count: 2) }
  let(:quiz_store) { QuizStore.new(hash, quiz) }

  before :each do
    allow(quiz).to receive(:id) { quiz_id }
    allow(quiz).to receive(:questions) { questions }
  end

  describe "#vote" do
    it "marks that a questions has been voted" do
      quiz_store.vote(123, true)

      expect(quiz_store.voted_for?(123)).to eql(true)
    end

    it "increases score for correct vote" do
      expect {
        quiz_store.vote(123, true)
      }.to change { quiz_store.score }
    end

    it "doesn't increase score for incorrect vote" do
      expect {
        quiz_store.vote(123, false)
      }.not_to change { quiz_store.score }
    end

    it "doesn't change score on double vote" do
      quiz_store.vote(123, true)

      expect {
        quiz_store.vote(123, true)
      }.not_to change { quiz_store.score }
    end

    it "doesn't allow more votes if all voted" do
      quiz_store.vote(123, true)
      quiz_store.vote(456, false)

      expect {
        quiz_store.vote(678, false)
      }.to raise_error(QuizStore::AllVotedError)
    end
  end

  describe "#voted_for?" do
    it "returns false if not voted for given question" do
      quiz_store.vote(123, true)

      expect(quiz_store.voted_for?(456)).to eql(false)
    end
  end

  describe "#all_voted?" do
    it "returns true if voted for all questions" do
      quiz_store.vote(123, true)
      quiz_store.vote(456, true)

      expect(quiz_store.all_voted?).to eql(true)
    end

    it "returns false if not voted for all questions" do
      quiz_store.vote(123, true)
      quiz_store.vote(123, true)

      expect(quiz_store.all_voted?).to eql(false)
    end
  end

  describe "#score" do
    it "returns score" do
      quiz_store.vote(123, true)
      quiz_store.vote(456, false)

      expect(quiz_store.score).to eql(50.0)
    end
  end
end

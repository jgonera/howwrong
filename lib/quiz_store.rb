class QuizStore
  class QuizStoreError < StandardError; end
  class AllVotedError < QuizStoreError; end

  def initialize(hash, quiz)
    @hash = hash
    @quiz = quiz

    @hash[@quiz.id] ||= { correct_count: 0, voted: {} }
    @quiz_hash = @hash[@quiz.id]
  end

  def vote(question_id, is_correct)
    raise AllVotedError if all_voted?

    unless voted_for?(question_id)
      @quiz_hash[:voted][question_id] = true
      @quiz_hash[:correct_count] += 1 if is_correct
    end
  end

  def voted_for?(question_id)
    @quiz_hash[:voted].has_key?(question_id)
  end

  def all_voted?
    @quiz_hash[:voted].length == @quiz.questions.count
  end

  def score
    @quiz_hash[:correct_count].to_f / @quiz.questions.count * 100
  end
end

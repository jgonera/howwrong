module Howwrong
  class VoteStore
    def initialize(hash)
      @hash = hash
    end

    def vote(question_id, answer_id)
      @hash[question_id] = answer_id
    end

    def answer_for(question_id)
      @hash[question_id]
    end

    def has_answer_for?(question_id)
      answer_for(question_id) != nil
    end

    def voted_questions
      @hash.keys
    end
  end
end

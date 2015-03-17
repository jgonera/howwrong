require "vote_store"

class BaseQuestionsController < ApplicationController
  before_action do
    @vote_store = VoteStore.new(session[:voted] ||= {})
  end

  def vote
    unless @vote_store.has_answer_for?(@question.id)
      answer = @question.answers.find(params[:answer_id])
      answer.increment!(:votes)
      @vote_store.vote(@question.id, answer.id)
    end

    redirect_to action: 'results'
  rescue ActiveRecord::RecordNotFound
    # mostly for answers that don't belong to the right question
    redirect_to action: 'results'
  end

  def results
    unless @vote_store.has_answer_for?(@question.id)
      redirect_to action: 'show'
      return
    end

    @vote_answer_id = @vote_store.answer_for(@question.id)
    @is_wrong = @vote_answer_id != @question.answers.correct.id
    @options = {
      answers: @question.answers,
      votes_count: @question.votes_count,
      vote_answer_id: @vote_answer_id
    }
  end
end

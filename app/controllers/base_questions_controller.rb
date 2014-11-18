class BaseQuestionsController < ApplicationController
  before_action do
    session[:voted] ||= {}
  end

  def show
    redirect_to action: 'results' if session[:voted].has_key? @question.id
  end

  def vote
    unless session[:voted].has_key?(@question.id)
      answer = @question.answers.find(params[:answer_id])
      answer.increment!(:votes)
      session[:voted][@question.id] = answer.id
    end

    redirect_to action: 'results'
  rescue ActiveRecord::RecordNotFound
    # mostly for answers that don't belong to the right question
    redirect_to action: 'results'
  end

  def results
    redirect_to action: 'show' unless session[:voted].has_key?(@question.id)

    @title = @question.text
    @vote_answer_id = session[:voted][@question.id]
    @is_wrong = @vote_answer_id != @question.answers.correct.id
    @options = {
      answers: @question.answers,
      votes_count: @question.votes_count,
      vote_answer_id: @vote_answer_id
    }
  end
end

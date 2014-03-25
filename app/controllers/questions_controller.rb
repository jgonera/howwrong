class QuestionsController < ApplicationController
  before_action do
    session[:voted] ||= {}
  end

  def index
    @question = Question.featured.where.not(id: session[:voted].keys).last
    render 'show'
  end

  def show
    @question = Question.friendly.find params[:id]
  end

  def vote
    question = Question.friendly.find params[:id]

    unless session[:voted][question.id]
      answer = question.answers.find(params[:answer_id])
      answer.increment! :votes
      session[:voted][question.id] = answer.id
    end

    redirect_to action: 'results'
  rescue ActiveRecord::RecordNotFound
    # mostly for answers that don't belong to the right question
    redirect_to action: 'results'
  end

  def results
    @question = Question.friendly.find params[:id]
    @vote_answer_id = session[:voted][@question.id]
    @options = { answers: @question.answers, vote_answer_id: @vote_answer_id }
    redirect_to action: 'show' unless session[:voted].has_key? @question.id
  end

  def short
    redirect_to action: 'show', id: Question.find(params[:id]).slug
  end
end

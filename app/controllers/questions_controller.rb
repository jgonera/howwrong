class QuestionsController < ApplicationController
  before_action do
    session[:voted] ||= {}
  end

  def index
    @question = Question.featured.where.not(id: session[:voted].keys).last

    if @question.nil?
      @questions = Question.all.limit(3)
      render 'archive'
    else
      render 'show'
    end
  end

  def archive
    @questions = Question.all
  end

  def show
    @question = Question.friendly.find params[:id]
    redirect_to action: 'results' if session[:voted].has_key? @question.id
  end

  def vote
    question = Question.friendly.find params[:id]

    unless session[:voted].has_key? question.id
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
    redirect_to action: 'show' unless session[:voted].has_key? @question.id

    @vote_answer_id = session[:voted][@question.id]
    @is_wrong = @vote_answer_id != @question.answers.correct.id
    @options = {
      answers: @question.answers,
      votes_count: @question.votes_count,
      vote_answer_id: @vote_answer_id
    }
  end

  def short
    redirect_to action: 'show', id: Question.find(params[:id]).slug
  end
end

class QuestionsController < ApplicationController
  before_action do
    session[:voted] ||= {}
  end

  def index
    @question = Question.last
    render 'show'
  end

  def show
    @question = Question.friendly.find params[:slug]
  end

  def vote
    question = Question.friendly.find params[:slug]

    question.answers.find(params[:answer_id]).increment! :votes unless session[:voted][question.id]
    session[:voted][question.id] = true

    redirect_to action: 'results'
  rescue ActiveRecord::RecordNotFound
    # mostly for answers that don't belong to the right question
    redirect_to action: 'results'
  end

  def results
    @question = Question.friendly.find params[:slug]
    redirect_to action: 'show' unless session[:voted].has_key? @question.id
  end
end

class QuestionsController < ApplicationController
  def index
    @question = Question.last
  end

  def vote
    session[:voted] ||= {}
    question = Question.friendly.find params[:slug]

    question.answers.find(params[:answer_id]).increment! :votes unless session[:voted][question.id]
    session[:voted][question.id] = true

    redirect_to action: 'results', slug: params[:slug]
  rescue ActiveRecord::RecordNotFound
    # mostly for answers that don't belong to the right question
    redirect_to action: 'results', slug: params[:slug]
  end

  def results
    @question = Question.friendly.find params[:slug]
  end
end

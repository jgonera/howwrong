class QuestionsController < ApplicationController
  def index
    @question = Question.last
  end

  def vote
    Answer.increment_counter :votes, params[:answer_id]
    redirect_to action: 'results', slug: params[:slug]
  end

  def results
    @question = Question.friendly.find params[:slug]
  end
end

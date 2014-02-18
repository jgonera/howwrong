class QuestionsController < ApplicationController
  def index
    @question = Question.last
  end

  def vote
    Answer.increment_counter :votes, params[:answer_id]
  end
end

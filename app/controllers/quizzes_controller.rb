class QuizzesController < ApplicationController
  def show
    @quiz = Quiz.friendly.find params[:id]
    @question = @quiz.questions.first
  end
end

class QuestionsController < ApplicationController
  def index
    @question = Question.last
  end
end

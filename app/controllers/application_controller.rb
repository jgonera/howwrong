class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render(*args)
    if !@questions
      if @question
        @other_questions = Question.random(3, exclude: @question)
      else
        @other_questions = Question.random(3)
      end
    end

    super
  end
end

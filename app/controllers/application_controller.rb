class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render(*args)
    if !@questions
      if @question
        @other_questions = Question.where('id != ?', @question.id)
      else
        @other_questions = Question.all
      end
    end

    super
  end
end

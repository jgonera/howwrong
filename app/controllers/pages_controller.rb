class PagesController < ApplicationController
  def about
    @title = "About"
    @other_questions = Question.random
  end

  def ask
    @title = "Submit question"
    @other_questions = Question.random
  end
end

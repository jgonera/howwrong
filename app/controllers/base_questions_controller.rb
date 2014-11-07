class BaseQuestionsController < ApplicationController
  before_action do
    session[:voted] ||= {}
  end
end

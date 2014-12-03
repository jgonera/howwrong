class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  def render(*args)
    if @title.nil?
      @title = ""
    else
      @title += " · "
    end
    @title += "How Wrong You Are"

    super
  end
end

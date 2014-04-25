class PagesController < ApplicationController
  def about
    @title = "About"
  end

  def ask
    @title = "Submit question"
  end
end

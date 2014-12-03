module ApplicationHelper
  protected

  def path_for(options = {})
    url_for(options.merge(only_path: true))
  end
end

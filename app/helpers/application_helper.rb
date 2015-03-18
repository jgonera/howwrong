module ApplicationHelper
  def page_title(title)
    if title.nil?
      "How Wrong You Are"
    else
      "#{title} · How Wrong You Are"
    end
  end

  protected

  def path_for(options = {})
    url_for(options.merge(only_path: true))
  end
end

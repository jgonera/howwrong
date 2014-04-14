require 'sass'

# FIXME: too hacky? is this the right place?
module Sass::Script::Functions
  def inline_svg(path)
    asset = Rails.application.assets[path.value]
    content = File.read(asset.pathname).gsub("#", "%23")
    Sass::Script::String.new("url('data:image/svg+xml;utf8,#{content}')")
  end
end

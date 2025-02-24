class Ui::Icon::Component < ApplicationComponent
  def initialize(filename:, **options)
    @filename = filename
    @options = options
  end

  def call
    helpers.inline_svg_tag(@filename, **@options)
  end
end
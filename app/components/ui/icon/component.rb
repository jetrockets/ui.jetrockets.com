class Ui::Icon::Component < ApplicationComponent
  def initialize(path:, **options)
    @path = path
    @options = options
  end

  def call
    helpers.vite_icon_tag(@path, @options)
  end
end

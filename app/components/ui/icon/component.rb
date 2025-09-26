class Ui::Icon::Component < ApplicationComponent
  def initialize(icon:, **options)
    @icon = icon
    @options = options
  end

  def call
    helpers.vite_icon_tag(@icon, @options)
  end
end

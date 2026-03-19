class Ui::Alert::IconComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    helpers.icon_tag content, **@options
  end
end

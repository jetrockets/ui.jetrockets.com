class Ui::Alert::IconComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    helpers.ui.icon content, **@options
  end
end

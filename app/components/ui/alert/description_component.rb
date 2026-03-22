class Ui::Alert::DescriptionComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "[.icon~&]:col-start-2",
      @options.delete(:class)
    )
  end
end

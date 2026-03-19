class Ui::Card::BodyComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:div, content, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "px-6 py-4",
      @options.delete(:class)
    )
  end
end

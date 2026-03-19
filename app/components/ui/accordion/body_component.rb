class Ui::Accordion::BodyComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "pb-3.5",
      @options.delete(:class)
    )
  end
end

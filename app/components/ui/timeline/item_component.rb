class Ui::Timeline::ItemComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "timeline-item",
      @options.delete(:class)
    )
  end
end

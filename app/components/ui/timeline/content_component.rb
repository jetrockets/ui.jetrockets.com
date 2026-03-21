class Ui::Timeline::ContentComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "timeline-content",
      @options.delete(:class)
    )
  end
end

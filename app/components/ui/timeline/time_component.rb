class Ui::Timeline::TimeComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :time, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "timeline-time",
      @options.delete(:class)
    )
  end
end

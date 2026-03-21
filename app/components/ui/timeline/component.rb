class Ui::Timeline::Component < ApplicationComponent
  def initialize(**options)
    super
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "timeline",
      @options.delete(:class)
    )
  end
end

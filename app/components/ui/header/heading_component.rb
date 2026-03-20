class Ui::Header::HeadingComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "relative flex-1",
      @options.delete(:class)
    )
  end
end

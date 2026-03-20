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
      "flex-1 flex flex-col gap-2",
      @options.delete(:class)
    )
  end
end

class Ui::Header::SubtitleComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :p, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "text-base text-gray-500",
      @options.delete(:class)
    )
  end
end

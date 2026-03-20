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
      "text-xl text-gray-600",
      @options.delete(:class)
    )
  end
end

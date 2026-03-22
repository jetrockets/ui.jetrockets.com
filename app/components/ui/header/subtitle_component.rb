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
      "text-base text-muted-foreground",
      @options.delete(:class)
    )
  end
end

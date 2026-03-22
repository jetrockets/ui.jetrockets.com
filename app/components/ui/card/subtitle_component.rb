class Ui::Card::SubtitleComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:span, content, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "text-sm text-muted-foreground",
      @options.delete(:class)
    )
  end
end

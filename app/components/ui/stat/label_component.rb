class Ui::Stat::LabelComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :p, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "text-sm font-medium text-muted-foreground",
      @options.delete(:class)
    )
  end
end

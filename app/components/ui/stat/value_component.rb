class Ui::Stat::ValueComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :p, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "text-2xl font-bold text-foreground mt-1",
      @options.delete(:class)
    )
  end
end

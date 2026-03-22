class Ui::Empty::DescriptionComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :p, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "text-muted-foreground mt-1",
      @options.delete(:class)
    )
  end
end

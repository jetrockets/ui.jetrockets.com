class Ui::List::ContentComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "list__content",
      @options.delete(:class)
    )
  end
end

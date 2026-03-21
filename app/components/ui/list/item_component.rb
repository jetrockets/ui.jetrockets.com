class Ui::List::ItemComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :li, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "list__item",
      @options.delete(:class)
    )
  end
end

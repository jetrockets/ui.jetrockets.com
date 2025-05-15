class Ui::Dropdown::ItemComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :li, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "dropdown__item",
      @options.delete(:class)
    )
  end
end

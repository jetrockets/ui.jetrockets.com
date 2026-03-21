class Ui::List::IconComponent < ApplicationComponent
  def initialize(name = nil, size: 5, **options)
    @name = name
    @size = size
    @options = options
  end

  def call
    content_tag :div, class: classes, **@options do
      helpers.ui.icon(@name || content, size: @size)
    end
  end

  private

  def classes
    class_names(
      "list__icon",
      @options.delete(:class)
    )
  end
end

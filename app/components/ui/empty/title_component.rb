class Ui::Empty::TitleComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :h3, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "text-xl font-semibold text-gray-900",
      @options.delete(:class)
    )
  end
end

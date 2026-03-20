class Ui::Header::TitleComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :h1, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "flex-1 mb-4 mr-2 text-2xl font-semibold tracking-wide md:text-4xl",
      @options.delete(:class)
    )
  end
end

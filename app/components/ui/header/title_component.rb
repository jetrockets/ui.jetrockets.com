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
      "flex-1 font-semibold tracking-light text-3xl",
      @options.delete(:class)
    )
  end
end

class Ui::Card::TitleComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:strong, content, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "flex items-center gap-2 text-lg font-semibold",
      @options.delete(:class)
    )
  end
end

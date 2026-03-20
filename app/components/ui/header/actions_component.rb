class Ui::Header::ActionsComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "flex items-center shrink-0 gap-2 whitespace-nowrap",
      @options.delete(:class)
    )
  end
end

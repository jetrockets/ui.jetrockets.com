class Ui::Chat::TypingComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, class: classes, **@options do
      safe_join(3.times.map { content_tag(:span, "", class: "chat__typing-dot") })
    end
  end

  private

  def classes
    class_names(
      "chat__typing",
      @options.delete(:class)
    )
  end
end

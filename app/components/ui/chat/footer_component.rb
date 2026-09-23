class Ui::Chat::FooterComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "chat__footer",
      @options.delete(:class)
    )
  end
end

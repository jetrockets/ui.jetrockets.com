class Ui::Chat::AuthorComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :span, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "chat__author",
      @options.delete(:class)
    )
  end
end

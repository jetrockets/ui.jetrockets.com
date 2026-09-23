class Ui::Chat::TimeComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :time, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "chat__time",
      @options.delete(:class)
    )
  end
end

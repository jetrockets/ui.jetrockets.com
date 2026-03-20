class Ui::Empty::Component < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "flex flex-col items-center text-center py-12 px-4",
      @options.delete(:class)
    )
  end
end

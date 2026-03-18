class Ui::Alert::TitleComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :strong, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "font-semibold",
      @options.delete(:class)
    )
  end
end

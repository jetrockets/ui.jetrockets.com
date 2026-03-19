class Ui::Drawer::BodyComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "drawer__body",
      @options.delete(:class)
    )
  end
end

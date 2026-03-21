class Ui::Sidebar::MenuComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:ul, content, class: classes, **@options.except(:class))
  end

  private

  def classes
    class_names(
      "sidebar__menu",
      @options[:class]
    )
  end
end

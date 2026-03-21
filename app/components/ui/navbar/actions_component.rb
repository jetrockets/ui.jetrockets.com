class Ui::Navbar::ActionsComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:div, content, class: classes, **@options.except(:class))
  end

  private

  def classes
    class_names(
      "navbar__actions",
      @options[:class]
    )
  end
end

class Ui::Navbar::MainComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:div, content, class: classes, **@options.except(:class))
  end

  private

  def classes
    class_names(
      "navbar__main",
      @options[:class]
    )
  end
end

class Ui::Navbar::Component < ApplicationComponent
  def initialize(sticky: true, **options)
    @sticky = sticky
    @options = options
  end

  def call
    content_tag(:header, content, class: classes, **@options.except(:class))
  end

  private

  def classes
    class_names(
      "navbar",
      @options[:class],
      "navbar-sticky" => @sticky
    )
  end
end

class Ui::Accordion::Component < ApplicationComponent
  def initialize(name: nil, open: false, **options)
    super
    @name = name
    @open = open
    @options = options
  end

  def call
    content_tag :details, content, class: classes, name: @name, open: @open, **@options
  end

  private

  def classes
    class_names(
      "group",
      @options.delete(:class)
    )
  end
end

class Ui::Table::Th::Component < ApplicationComponent
  def initialize(sticky: nil, **options)
    @sticky = sticky
    @options = options
  end

  def call
    content_tag :th, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      @options.delete(:class),
      "table__th_sticky": @sticky,
      "table__th_sticky-left": @sticky == :left,
      "table__th_sticky-right": @sticky == :right
    )
  end
end

class Ui::Card::FooterComponent < ApplicationComponent
  def initialize(direction: :row, align: :start, justify: :start, bordered: true, **options)
    @direction = direction
    @align = align
    @justify = justify
    @bordered = bordered
    @options = options
  end

  def call
    content_tag(:div, content, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "flex px-6 pb-4",
      direction_class,
      align_class,
      justify_class,
      { "pt-4 border-t border-gray-200": @bordered },
      @options.delete(:class)
    )
  end

  def direction_class
    {
      col: "flex-col gap-1",
      row: "flex-row gap-4"
    }[@direction]
  end

  def align_class
    {
      start: "items-start",
      center: "items-center",
      end: "items-end"
    }[@align]
  end

  def justify_class
    {
      start: "justify-start",
      center: "justify-center",
      end: "justify-end",
      between: "justify-between"
    }[@justify]
  end
end

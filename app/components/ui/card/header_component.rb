class Ui::Card::HeaderComponent < ApplicationComponent
  def initialize(direction: :col, align: :start, justify: :start, bordered: true, **options)
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
      "flex px-6 pt-4",
      direction_class,
      align_class,
      justify_class,
      { "pb-4 border-b border-gray-200": @bordered },
      @options.delete(:class)
    )
  end

  def direction_class
    {
      col: "flex-col gap-1",
      row: "flex-row gap-6"
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

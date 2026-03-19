class Ui::Drawer::FooterComponent < ApplicationComponent

  def initialize(direction: :row, align: :start, justify: :start, bordered: true, **options)
    @direction = direction
    @align = align
    @justify = justify
    @bordered = bordered
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "drawer__footer",
      { "drawer__footer-bordered": @bordered },
      direction_class,
      align_class,
      justify_class,
      @options.delete(:class)
    )
  end

  def direction_class
    {
      col: "flex flex-col gap-2",
      row: "flex flex-row gap-2"
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

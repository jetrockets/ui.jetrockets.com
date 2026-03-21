class Ui::Header::Component < ApplicationComponent
  def initialize(direction: :row, align: :start, justify: :between, sticky: false, bordered: false, **options)
    @direction = direction
    @align = align
    @justify = justify
    @sticky = sticky
    @bordered = bordered
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "flex gap-y-2 gap-x-8 lg:gap-x-16 py-3 md:py-6",
      direction_class,
      align_class,
      justify_class,
      { "lg:sticky lg:z-30 lg:top-navbar bg-white/90 backdrop-blur-xs": @sticky },
      { "pb-4 border-b border-gray-200": @bordered },
      @options.delete(:class)
    )
  end

  def direction_class
    {
      col: "flex-col",
      row: "flex-col md:flex-row"
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

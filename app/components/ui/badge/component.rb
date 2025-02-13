class Ui::Badge::Component < ApplicationComponent
  TYPES = %i[default blue red green yellow]
  DEFAULT_TYPE = :default
  SIZES = %i[default xs sm md lg]
  DEFAULT_SIZE = :md

  def initialize(title:, type: DEFAULT_TYPE, size: DEFAULT_SIZE,  **options)
    @type = TYPES.include?(type) ? type : DEFAULT_TYPE
    @size = SIZES.include?(size) ? size : DEFAULT_SIZE
    @title = title
    @options = options
  end

  def call
    content_tag :span, @title, class: classes, **@options
  end

  def classes
    class_names(
      "font-medium inline-flex items-center justify-center rounded",
      @options.delete(:class),
      "bg-gray-100 text-gray-800": @type == :default,
      "bg-blue-100 text-blue-800": @type == :blue,
      "bg-red-100 text-red-800": @type == :red,
      "bg-green-100 text-green-800": @type == :green,
      "bg-yellow-100 text-yellow-800": @type == :yellow,
      "text-xs px-2.5 py-1.5": @size == :xs,
      "text-sm px-3 py-1.5": @size == :sm,
      "text-md px-2.5 py-1.5": @size == :md,
      "text-lg px-2.5 py-1.5": @size == :lg,
    )
  end
end

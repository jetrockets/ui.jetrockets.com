class Ui::Badge::Component < ApplicationComponent
  TYPES = %i[default blue red green yellow]
  DEFAULT_TYPE = :default
  SIZES = %i[xs sm md lg]
  DEFAULT_SIZE = :sm

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
      "font-medium inline-flex items-center rounded-md ring-1 ring-inset",
      @options.delete(:class),
      "bg-gray-100 text-gray-800 ring-gray-800/20": @type == :default,
      "bg-blue-100 text-blue-800 ring-blue-800/20": @type == :blue,
      "bg-red-100 text-red-800 ring-red-800/20": @type == :red,
      "bg-green-100 text-green-800 ring-green-800/20": @type == :green,
      "bg-yellow-100 text-yellow-800 ring-yellow-800/20": @type == :yellow,
      "px-1.5 py-0.5 text-xs": @size == :xs,
      "px-2 py-1 text-xs": @size == :sm,
      "px-3 py-1 text-sm": @size == :md,
      "px-4 py-2 text-sm": @size == :lg,
    )
  end
end

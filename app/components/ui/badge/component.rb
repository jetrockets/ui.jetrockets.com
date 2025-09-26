class Ui::Badge::Component < ApplicationComponent
  VARIANTS = %i[default blue red green yellow]
  DEFAULT_VARIANT = :default
  SIZES = %i[xs sm md lg]
  DEFAULT_SIZE = :sm

  def initialize(title:, variant: DEFAULT_VARIANT, size: DEFAULT_SIZE,  **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @size = SIZES.include?(size) ? size : DEFAULT_SIZE
    @title = title
    @options = options
  end

  def call
    content_tag :span, @title, class: classes, **@options
  end

  def classes
    class_names(
      "font-semibold inline-flex items-center rounded-md w-fit",
      @options.delete(:class),
      "bg-gray-100 text-gray-800": @variant == :default,
      "bg-blue-100 text-blue-800": @variant == :blue,
      "bg-red-100 text-red-800": @variant == :red,
      "bg-green-100 text-green-800": @variant == :green,
      "bg-yellow-100 text-yellow-800": @variant == :yellow,
      "px-1.5 py-0.5 text-xs": @size == :xs,
      "px-2 py-1 text-xs": @size == :sm,
      "px-3 py-1 text-sm": @size == :md,
      "px-4 py-2 text-sm": @size == :lg,
    )
  end
end

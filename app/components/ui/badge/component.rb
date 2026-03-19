class Ui::Badge::Component < ApplicationComponent
  VARIANTS = %i[default info error success warning]
  DEFAULT_VARIANT = :default
  SIZES = %i[xs sm md lg]
  DEFAULT_SIZE = :sm

  def initialize(variant: DEFAULT_VARIANT, size: DEFAULT_SIZE, rounded: false, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @size = SIZES.include?(size) ? size : DEFAULT_SIZE
    @rounded = rounded
    @options = options
  end

  def call
    content_tag :span, content, class: classes, **@options
  end

  def classes
    class_names(
      "font-semibold inline-flex items-center w-fit whitespace-nowrap",
      @options.delete(:class),
      variant_classes,
      "px-1.5 py-0.5 text-[10px]": @size == :xs,
      "px-2 py-1 text-[11px]": @size == :sm,
      "px-3 py-1.5 text-xs": @size == :md,
      "px-4 py-2 text-[13px]": @size == :lg,
      "rounded-full": @rounded,
      "rounded-md": !@rounded
    )
  end

  def variant_classes
    {
      default: "bg-gray-50 border-gray-200 text-gray-800",
      info: "bg-blue-50 border-blue-200 text-blue-800",
      error: "bg-red-50 border-red-200 text-red-800",
      success: "bg-green-50 border-green-300 text-green-800",
      warning: "bg-yellow-50 border-yellow-300 text-yellow-800"
    }[@variant]
  end
end

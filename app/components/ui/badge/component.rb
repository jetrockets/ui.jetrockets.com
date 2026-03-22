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
      "rounded-[var(--radius-button)]": !@rounded
    )
  end

  def variant_classes
    {
      default: "bg-muted border-border text-foreground",
      info: "bg-info-soft border-info-border text-info-soft-foreground",
      error: "bg-destructive-soft border-destructive-border text-destructive-soft-foreground",
      success: "bg-success-soft border-success-border text-success-soft-foreground",
      warning: "bg-warning-soft border-warning-border text-warning-soft-foreground"
    }[@variant]
  end
end

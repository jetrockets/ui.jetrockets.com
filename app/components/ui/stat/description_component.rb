class Ui::Stat::DescriptionComponent < ApplicationComponent
  VARIANTS = %i[default success warning error]
  DEFAULT_VARIANT = :default

  def initialize(variant: DEFAULT_VARIANT, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @options = options
  end

  def call
    content_tag :p, class: classes, **@options do
      safe_join([trend_icon, content].compact)
    end
  end

  private

  def classes
    class_names(
      "text-sm mt-2 flex items-center gap-1",
      @options.delete(:class),
      variant_classes
    )
  end

  def variant_classes
    {
      default: "text-gray-500",
      success: "text-green-600",
      warning: "text-yellow-600",
      error: "text-red-600"
    }[@variant]
  end

  def trend_icon
    return nil if @variant == :default

    icon_name = @variant == :success ? "arrow-trending-up" : "arrow-trending-down"
    helpers.ui.icon(icon_name, size: 4)
  end
end

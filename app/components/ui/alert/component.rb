class Ui::Alert::Component < ApplicationComponent
  VARIANTS = %i[default info error success warning]
  DEFAULT_VARIANT = :default

  def initialize(title: nil, variant: DEFAULT_VARIANT, **options)
    @title = title
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @options = options
  end

  def call
    content_tag :div, class: classes, **@options do
      concat helpers.ui.alert_title(@title) if @title.present?
      concat content
    end
  end

  private

  def classes
    class_names(
      "grid items-center gap-x-2 px-3.5 py-3 rounded-xl border text-sm",
      "has-[.icon]:grid-cols-[auto_1fr]",
      variant_classes,
      @options.delete(:class)
    )
  end

  def variant_classes
    {
      default: "bg-gray-50 border-gray-200",
      info: "bg-blue-50 border-blue-200",
      error: "bg-red-50 border-red-200",
      success: "bg-green-50 border-green-300",
      warning: "bg-yellow-50 border-yellow-300"
    }[@variant]
  end
end

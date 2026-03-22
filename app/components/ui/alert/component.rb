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
      "grid items-center gap-x-2 px-3.5 py-3 rounded-card border text-sm",
      "has-[.icon]:grid-cols-[auto_1fr]",
      variant_classes,
      @options.delete(:class)
    )
  end

  def variant_classes
    {
      default: "bg-muted border-border",
      info: "bg-info-soft border-info-border",
      error: "bg-destructive-soft border-destructive-border",
      success: "bg-success-soft border-success-border",
      warning: "bg-warning-soft border-warning-border"
    }[@variant]
  end
end

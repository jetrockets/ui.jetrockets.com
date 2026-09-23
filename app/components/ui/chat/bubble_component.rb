class Ui::Chat::BubbleComponent < ApplicationComponent
  VARIANTS = %i[default primary muted]
  DEFAULT_VARIANT = :default

  def initialize(variant: DEFAULT_VARIANT, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "chat__bubble",
      "chat__bubble-#{@variant}",
      @options.delete(:class)
    )
  end
end

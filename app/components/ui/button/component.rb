class Ui::Button::Component < ApplicationComponent
  renders_one :icon

  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  VARIANTS = %i[primary secondary danger ghost link]

  def initialize(variant: nil, size: DEFAULT_SIZE, rounded: false, block: false, circle: false, outlined: false, **options)
    @variant = variant
    @size = size
    @rounded = rounded
    @circle = circle
    @outlined = outlined
    @block = block
    @options = options
  end

  def call
    button_tag(**button_attributes) do
      concat(content_tag(:span, content)) if content?
      concat(helpers.vite_svg_tag(icon, class: icon_classes)) if icon?
    end
  end

  private

  def button_attributes
    {
      class: class_names(
        "btn",
        variant_class,
        @options.delete(:class),
        "btn-#{@size}",
        "btn-block": @block,
        "btn-rounded": @rounded,
        "btn-circle": @circle,
        "btn-outlined": @outlined
      ),
      **@options
    }
  end

  def variant_class
    case @variant
    when :primary
      "btn-primary"
    when :secondary
      "btn-secondary"
    when :danger
      "btn-danger"
    when :ghost
      "btn-ghost"
    when :link
      "btn-link"
    end
  end

  def icon_classes
    class_names(
      "btn__icon",
      "btn__icon-xs": @size == :xs,
      "btn__icon-sm": @size == :sm,
      "btn__icon-md": @size == :md,
      "btn__icon-lg": @size == :lg,
      "btn__icon-xl": @size == :xl
    )
  end
end

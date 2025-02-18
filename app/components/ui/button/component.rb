class Ui::Button::Component < ApplicationComponent
  renders_one :icon

  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  VARIANTS = %i[primary secondary danger ghost link]

  def initialize(variant: nil, href: nil, size: DEFAULT_SIZE, rounded: false, block: false, circle: false, outlined: false, **options)
    @variant = variant
    @href = href
    @size = size
    @rounded = rounded
    @block = block
    @circle = circle
    @outlined = outlined
    @options = options
  end

  def call
    if @href
      link_to component_content, @href, **button_attributes
    else
      button_tag component_content, **button_attributes
    end
  end

  private

  def component_content
    safe_join([ content, icon_content ].compact)
  end

  def icon_content
    helpers.vite_svg_tag(icon, class: icon_classes) if icon?
  end

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
    variant_classes = {
      primary: "btn-primary",
      secondary: "btn-secondary",
      danger: "btn-danger",
      ghost: "btn-ghost",
      link: "btn-link"
    }.freeze

    variant_classes[@variant]
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

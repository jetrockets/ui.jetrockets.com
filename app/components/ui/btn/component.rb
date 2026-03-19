class Ui::Btn::Component < ApplicationComponent
  SIZES = %i[xs sm md lg icon_xs icon_sm icon_md icon_lg]
  DEFAULT_SIZE = :md

  VARIANTS = %i[default outline secondary danger ghost link]
  DEFAULT_VARIANT = :default

  def initialize(variant: DEFAULT_VARIANT, url: nil, size: DEFAULT_SIZE, rounded: false, block: false, circle: false, method: nil, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @url = url
    @size = SIZES.include?(size) ? size : DEFAULT_SIZE
    @rounded = rounded
    @block = block
    @circle = circle
    @method = method
    @options = options
  end

  def call
    if @url && @method
      button_to @url, class: classes, method: @method, **@options do
        content
      end
    elsif @url
      link_to content, @url, class: classes, **@options
    else
      button_tag content, type: "button", class: classes, **@options
    end
  end

  private

  def classes
    class_names(
      "btn",
      variant_class,
      "btn-#{@size}",
      { "btn-block": @block },
      { "btn-rounded": @rounded },
      { "btn-circle": @circle },
      @options.delete(:class),
    )
  end

  def variant_class
    {
      default: "btn-default",
      outline: "btn-outline",
      secondary: "btn-secondary",
      danger: "btn-danger",
      ghost: "btn-ghost",
      link: "btn-link"
    }[@variant]
  end
end

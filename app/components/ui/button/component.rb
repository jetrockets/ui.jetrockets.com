class Ui::Button::Component < ApplicationComponent
  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :sm

  VARIANTS = %i[primary secondary danger ghost link]
  DEFAULT_VARIANT = :default

  TYPES = %i[button submit reset]
  DEFAULT_TYPE = :button

  def initialize(variant: DEFAULT_VARIANT, type: DEFAULT_TYPE, size: DEFAULT_SIZE, title: nil, rounded: false, circle: false, outlined: false, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @type = TYPES.include?(type) ? type : DEFAULT_TYPE
    @title = title
    @size = size
    @rounded = rounded
    @circle = circle
    @outlined = outlined
    @options = options
  end

  def call
    content_tag(:button, @title, type: @type, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "btn",
      variant_class,
      size_class,
      rounded_class,
      circle_class,
      outlined_class,
      @options.delete(:class)
    )
  end

  def variant_class
    case @variant
    when :primary
      "btn-primary"
    when :secondary
      "btn-secondary"
    when :danger
      "btn-danger"
    when :outlined
      "btn-outlined"
    when :ghost
      "btn-ghost"
    when :link
      "btn-link"
    when :default
      "btn"
    else
      "btn"
    end
  end

  def size_class
    case @size
    when :xs
      "btn-xs"
    when :sm
      "btn-sm"
    when :md
      "btn-md"
    when :lg
      "btn-lg"
    when :xl
      "btn-xl"
    else
      "btn-sm"
    end
  end

  def rounded_class
    @rounded ? "btn-rounded" : ""
  end

  def circle_class
    @circle ? "btn-circle" : ""
  end

  def outlined_class
    @outlined ? "btn-outlined" : ""
  end
end
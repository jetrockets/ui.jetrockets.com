class Ui::Button::Component < ApplicationComponent
  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :sm

  VARIANTS = %i[btn primary secondary danger ghost link]
  DEFAULT_VARIANT = :btn

  TYPES = %i[button submit reset]
  DEFAULT_TYPE = :button

  def initialize(variant: DEFAULT_VARIANT, type: DEFAULT_TYPE, size: DEFAULT_SIZE, title: nil, icon_path: nil, rounded: false, circle: false, outlined: false, **options)
    @variant = variant
    @type = type
    @title = title
    @icon_path = icon_path
    @size = size
    @rounded = rounded
    @circle = circle
    @outlined = outlined
    @options = options
  end

  def call
    content_tag(:button, type: @type, class: classes, **@options) do
      if icon
        concat(content_tag(:div, class: "flex items-center justify-center #{'mr-2' if @title} w-full h-full p-0 m-0") do
          concat(icon)
        end)
      end
      concat(@title) if @title
    end
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
    when :ghost
      "btn-ghost"
    when :link
      "btn-link"
    when :btn
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

  def icon
    if @icon_path
      helpers.vite_svg_tag @icon_path, class: "shrink-0"
    end
  end
end
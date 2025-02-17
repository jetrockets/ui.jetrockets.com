class Ui::Button::Component < ApplicationComponent
  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :sm

  VARIANTS = %i[btn primary secondary danger ghost link]
  DEFAULT_VARIANT = :btn

  def initialize(variant: DEFAULT_VARIANT, size: DEFAULT_SIZE, title: nil, icon_path: nil, rounded: false, circle: false, outlined: false, **options)
    @variant = variant
    @title = title
    @icon_path = icon_path
    @size = size
    @rounded = rounded
    @circle = circle
    @outlined = outlined
    @options = options
  end

  def call
    content_tag(:button, class: classes, **@options) do
      concat(icon) if @icon_path
      concat(@title) if @title
    end
  end

  private

  def classes
    class_names(
      "btn",
      variant_class,
      "btn-#{@size}",
      ("btn-rounded" if @rounded),
      ("btn-circle" if @circle),
      ("btn-outlined" if @outlined),
      @options.delete(:class),
      ("gap-2" if @icon_path && @title),
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
    end
  end

  def icon
    if @icon_path
      helpers.vite_svg_tag @icon_path, class: "shrink-0"
    end
  end
end
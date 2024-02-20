class Ui::Button::Component < ApplicationComponent
  VARIANTS = %i[primary secondary danger]

  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  def initialize(title: nil, variant: nil, outlined: false, size: DEFAULT_SIZE, href: nil, **options)
    @title = title
    @variant = VARIANTS.include?(variant) ? variant : nil
    @outlined = outlined
    @size = SIZES.include?(size) ? size : DEFAULT_SIZE
    @href = href
    @options = options
  end

  def call
    body ||= @title ? @title : content

    if @href.present?
      link_to body, @href, class: classes, **@options
    else
      content_tag :button, body, type: :button, class: classes, **@options
    end
  end

  def classes
    class_names(
      "btn",
      "btn-xs": @size == :xs,
      "btn-sm": @size == :sm,
      "btn-md": @size == :md,
      "btn-lg": @size == :lg,
      "btn-xl": @size == :xl,
      "btn-primary": @variant == :primary,
      "btn-secondary": @variant == :secondary,
      "btn-danger": @variant == :danger,
      "btn-outlined": @outlined
    )
  end
end

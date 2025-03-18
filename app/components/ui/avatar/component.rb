class Ui::Avatar::Component < ApplicationComponent
  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  VARIANTS = %i[rounded circle]
  DEFAULT_VARIANT = :circle

  def initialize(size: DEFAULT_SIZE, name: nil, variant: DEFAULT_VARIANT, **options)
    @size = size
    @name = name
    @variant = variant
    @options = options
  end

  def call
    content_tag :div, icon_content, class: avatar_classes
  end

  private

  def icon_content
    if @name.present?
      content_tag(:span, initials, class: name_classes)
    else
      helpers.vite_svg_tag("images/icons/user.svg", class: icon_classes)
    end
  end

  def initials
    @name.split.map { |word| word[0] }.join.upcase[0..1]
  end

  def avatar_classes
    class_names(
      "avatar",
      @options.delete(:class),
      "avatar-#{@size}",
      "avatar-rounded": roudned?,
      "avatar-circle": circle?
    )
  end

  def icon_classes
    class_names(
      "avatar__icon",
      "avatar__icon-#{@size}"
    )
  end

  def name_classes
    class_names(
      "text-xs": @size == :xs,
      "text-sm": @size == :sm,
      "text-base": @size == :md,
      "text-lg": @size == :lg,
      "text-xl": @size == :xl
    )
  end

  def roudned?
    @variant == :rounded
  end

  def circle?
    @variant == :circle
  end
end

class Ui::Avatar::Component < ApplicationComponent
  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  VARIANTS = %i[rounded circle]
  DEFAULT_VARIANT = :circle

  def initialize(size: DEFAULT_SIZE, full_name: nil, variant: DEFAULT_VARIANT, **options)
    @size = size
    @full_name = full_name
    @variant = variant
    @options = options
  end

  def call
    content_tag :div, icon_content, class: avatar_classes
  end

  private

  def icon_content
    if @full_name.present?
      content_tag(:span, initials, class: name_classes)
    else
      helpers.vite_svg_tag("images/icons/user.svg", class: "avatar__icon")
    end
  end

  def initials
    @full_name.split.map { |word| word[0] }.join.upcase[0..1]
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

class Ui::Avatar::Component < ApplicationComponent
  VARIANTS = %i[rounded circle square]
  DEFAULT_VARIANT = :circle
  DEFAULT_SIZE = 12

  def initialize(size: DEFAULT_SIZE, full_name: nil, variant: DEFAULT_VARIANT, **options)
    @size = size
    @full_name = full_name
    @variant = variant
    @options = options
  end

  def call
    content_tag :div, icon_content, class: avatar_classes, style: "--size: #{@size}"
  end

  private

  def icon_content
    # TODO: Add account avatar if exists

    if @full_name.present?
      content_tag(:span, initials, class: "avatar__initials")
    else
      concat helpers.vite_icon_tag("user.svg", class: "avatar__icon")
      concat content_tag(:span, class: "sr-only") { "Avatar thumbnail" }
    end
  end

  def initials
    @full_name.split.map { |word| word[0] }.join.upcase[0..1]
  end

  def avatar_classes
    class_names(
      "avatar",
      @options.delete(:class),
      "avatar-square": @variant == :square,
      "avatar-rounded": @variant == :rounded,
      "avatar-circle": @variant == :circle
    )
  end
end

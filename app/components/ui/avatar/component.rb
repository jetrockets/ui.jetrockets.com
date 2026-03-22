class Ui::Avatar::Component < ApplicationComponent
  VARIANTS = %i[rounded circle square]
  DEFAULT_VARIANT = :circle
  DEFAULT_SIZE = 12

  def initialize(user: nil, size: DEFAULT_SIZE, variant: DEFAULT_VARIANT, **options)
    @user = user
    @size = size
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @options = options
  end

  def call
    content_tag :div, icon_content, class: avatar_classes, style: avatar_style
  end

  private

  def icon_content
    if image_url
      return helpers.image_tag image_url, alt: @user.full_name, class: "size-full object-cover"
    end

    if @user&.full_name.present?
      return content_tag(:span, initials)
    end

    helpers.ui.icon("user", class: "w-8/12")
  end

  def image_url
    return false if !@user || !@user.avatar
    @user.avatar_url(:square_300) || @user.avatar_url
  end

  def initials
    @user.full_name.split.map { |word| word[0] }.join.upcase[0..1]
  end

  def avatar_classes
    class_names(
      "relative flex items-center justify-center overflow-hidden font-medium text-muted-foreground bg-muted",
      { "rounded-lg": @variant == :rounded },
      { "rounded-full": @variant == :circle },
      @options.delete(:class)
    )
  end

  def avatar_style
    size = "calc(var(--spacing) * #{@size})"
    font_size = (@size * 1.65).round(1)
    "width: #{size}; height: #{size}; font-size: #{font_size}px"
  end
end

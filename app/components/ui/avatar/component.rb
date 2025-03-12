class Ui::Avatar::Component < ApplicationComponent
  renders_one :icon

  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  def initialize(size: DEFAULT_SIZE, name: nil, rounded: false, circle: false, bordered: false, **options)
    @size = size
    @name = name
    @rounded = rounded
    @circle = circle
    @bordered = bordered
    @options = options
  end

  def call
    content_tag :div, icon_content, class: avatar_classes
  end

  private

  def icon_content
    if icon?
      helpers.vite_svg_tag(icon, class: icon_classes)
    elsif @name.present?
      initials
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
      "avatar-rounded": @rounded,
      "avatar-circle": @circle,
      "avatar-bordered": @bordered
    )
  end

  def icon_classes
    class_names(
      "avatar__icon",
      "avatar__icon-#{@size}"
    )
  end
end
class Ui::Button::Component < ApplicationComponent
  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :sm
  TYPES = %i[primary secondary danger ghost link]
  DEFAULT_TYPE = :default

  def initialize(type: DEFAULT_TYPE, size: DEFAULT_SIZE, title: nil, rounded: false, circle: false, outlined: false, **options)
    @type = TYPES.include?(type) ? type : DEFAULT_TYPE
    @title = title
    @size = size
    @rounded = rounded
    @circle = circle
    @outlined = outlined
    @options = options
  end

  def call
    content_tag(:button, @title, class: classes, **@options)
  end

  private

  def classes
    class_names(
      'btn',
      type_class,
      size_class,
      rounded_class,
      circle_class,
      outlined_class,
      @options.delete(:class)
    )
  end

  def type_class
    case @type
    when :primary
      'btn-primary'
    when :secondary
      'btn-secondary'
    when :danger
      'btn-danger'
    when :outlined
      'btn-outlined'
    when :ghost
      'btn-ghost'
    when :link
      'btn-link'
    when :default
      'btn'
    else
      'btn'
    end
  end

  def size_class
    case @size
    when :xs
      'btn-xs'
    when :sm
      'btn-sm'
    when :md
      'btn-md'
    when :lg
      'btn-lg'
    when :xl
      'btn-xl'
    else
      'btn-sm'
    end
  end

  def rounded_class
    @rounded ? 'btn-rounded' : ''
  end

  def circle_class
    @circle ? 'btn-circle' : ''
  end

  def outlined_class
    @outlined ? 'btn-outlined' : ''
  end
end
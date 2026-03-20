class Ui::Icon::Component < ApplicationComponent
  def initialize(size: nil, img: false, **options)
    @size = size
    @img = img
    @options = options
  end

  def call
    name = content.presence || @options.delete(:name)
    content_tag :span, nil, class: classes(name), "aria-hidden": true, "aria-label": name.to_s.humanize, **@options
  end

  def classes(name)
    class_names(
      "icon",
      "icon-#{name}",
      @options.delete(:class),
      "size-#{@size}": @size,
      "icon-img": @img
    )
  end
end

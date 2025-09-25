class Ui::Card::Footer::Component < ApplicationComponent
  def initialize(align: :right, bordered: true, **options)
    @align = align
    @bordered = bordered
    @options = options
  end

  def call
    content_tag(:div, content, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "card__footer",
      align_class,
      @options.delete(:class),
      "card__footer-bordered": @bordered
    )
  end

  def align_class
    {
      left: "items-start",
      center: "items-center",
      right: "items-end"
    }[@align]
  end
end

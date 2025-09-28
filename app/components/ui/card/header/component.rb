class Ui::Card::Header::Component < ApplicationComponent
  def initialize(title: nil, subtitle: nil, align: :left, bordered: true, **options)
    @title = title
    @subtitle = subtitle
    @align = align
    @bordered = bordered
    @options = options
  end

  def call
    content_tag(:div, class: classes, **@options) do
      concat content_tag(:strong, @title, class: "card__title") if @title.present?
      concat content_tag(:span, @subtitle, class: "card__subtitle") if @subtitle.present?
      concat content
    end
  end

  private

  def classes
    class_names(
      "card__header",
      align_class,
      @options.delete(:class),
      "card__header-bordered": @bordered
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

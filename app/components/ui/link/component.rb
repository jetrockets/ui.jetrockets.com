class Ui::Link::Component < Ui::Button::Component
  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  VARIANTS = %i[primary secondary danger ghost link]

  def initialize(href: "#", **options)
    super(**options)
    @href = href
  end

  def call
    link_to @href, **button_attributes do
      concat(content_tag(:span, content)) if content?
      concat(helpers.vite_svg_tag(icon, class: icon_classes)) if icon?
    end
  end
end

class Ui::Dropdown::ButtonComponent < ApplicationComponent
  def initialize(href: nil, **options)
    @href = href
    @options = options
  end

  erb_template <<~ERB
    <li class="dropdown__item">
      <%= button_to content, @href, **@options, class: classes, form: { class: "dropdown__form" } %>
    </li>
  ERB

  private

  def classes
    class_names(
      "dropdown__link",
      @options.delete(:class)
    )
  end
end

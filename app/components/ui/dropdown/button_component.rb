class Ui::Dropdown::ButtonComponent < ApplicationComponent
  def initialize(title: nil, href: nil, **options)
    @title = title
    @href = href
    @options = options
  end

  erb_template <<~ERB
    <%= render Ui::Dropdown::ItemComponent.new do %>
      <%= button_to @title, @href, **@options, class: classes, form: { class: "dropdown__form" } %>
    <% end %>
  ERB

  private

  def classes
    class_names(
      "dropdown__link",
      @options.delete(:class)
    )
  end
end

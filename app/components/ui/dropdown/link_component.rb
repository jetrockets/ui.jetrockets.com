class Ui::Dropdown::LinkComponent < ApplicationComponent
  def initialize(title: nil, href: nil, **options)
    @title = title
    @href = href
    @options = options
  end

  erb_template <<~ERB
    <%= render Ui::Dropdown::ItemComponent.new do %>
      <%= link_to @title, @href, class: classes, **@options %>
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

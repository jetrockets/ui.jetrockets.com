class Ui::Tabs::ItemComponent < ApplicationComponent
  def initialize(href:, icon: nil, active: false, **options)
    @href = href
    @icon = icon
    @active = active
    @options = options
  end

  erb_template <<~ERB
    <li class="tabs__item">
      <%= link_to @href, class: link_classes, **@options do %>
        <% if @icon %>
          <%= helpers.ui.icon(@icon, size: 4) %>
        <% end %>
        <%= content %>
      <% end %>
    </li>
  ERB

  private

  def link_classes
    class_names(
      "tabs__link",
      { "tabs__link-active": @active },
      @options.delete(:class)
    )
  end
end

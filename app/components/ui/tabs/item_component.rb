class Ui::Tabs::ItemComponent < ApplicationComponent
  def initialize(title:, href:, icon: nil, active: false, **options)
    @title = title
    @href = href
    @icon = icon
    @active = active
    @options = options
  end

  erb_template <<~ERB
    <%= link_to @href, class: class_names('tabs__link', 'tabs__link-active': @active), **@options do %>
      <% if @icon %>
        <%= helpers.icon_tag(@icon, size: 4) %>
      <% end %>
      <%= @title %>
    <% end %>
  ERB
end

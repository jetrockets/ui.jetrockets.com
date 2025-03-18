class Ui::Breadcrumb::ItemComponent < ApplicationComponent
  attr_reader :title, :href, :icon_path, :separator, :active, :options

  def initialize(title:, href: nil, icon_path: nil, separator: nil, active: false, **options)
    @title = title
    @href = href
    @icon_path = icon_path
    @separator = separator
    @active = active
    @options = options
  end

  erb_template <<~ERB
    <li class="breadcrumb__item">
      <%= link_to href, class: class_names("breadcrumb__link", "breadcrumb__link-active": active), **options do %>
        <div class="flex items-center gap-2">
          <% if icon_path %>
            <%= render Ui::Icon::Component.new(icon_path: icon_path, class: "w-4 h-4") %>
          <% end %>
          <%= title %>
        </div>
      <% end %>
      <% if separator %>
        <%= render Ui::Icon::Component.new(icon_path: separator, class: "w-4 h-4 mx-2") %>
      <% end %>
    </li>
  ERB
end

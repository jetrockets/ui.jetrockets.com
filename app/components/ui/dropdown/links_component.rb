class Ui::Dropdown::LinksComponent < ApplicationComponent
  def initialize(name:, icon_path: nil, href: nil, as: :link, disabled: false, **options)
    super
    @name = name
    @icon_path = icon_path
    @href = href
    @as = as
    @disabled = disabled
    @options = options
  end

  erb_template <<~ERB
    <li class="dropdown__item">
      <% if @as == :link %>
        <%= link_to @href, class: classes, **@options do %>
          <%= helpers.inline_svg_vite_tag(@icon_path, class: "dropdown__icon") if @icon_path %>
          <span><%= @name %></span>
        <% end %>
      <% elsif @as == :button %>
        <%= content_tag :span, class: classes, **@options do %>
          <%= helpers.inline_svg_vite_tag(@icon_path, class: "dropdown__icon") if @icon_path %>
          <span><%= @name %></span>
        <% end %>
      <% elsif @as == :title %>
        <strong class="dropdown__title">
          <%= @name %>
        </strong>
      <% end %>
    </li>
  ERB

  private

  def classes
    class_names(
      "dropdown__link": true,
      "dropdown__link-disabled": @disabled
    )
  end
end

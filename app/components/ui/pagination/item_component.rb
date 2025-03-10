class Ui::Pagination::ItemComponent < ApplicationComponent
  attr_reader :title, :href, :icon_path, :active, :direction, :options

  def initialize(title: nil, href: nil, icon_path: nil, active: false, direction: nil, **options)
    @title = title
    @href = href
    @icon_path = icon_path
    @active = active
    @direction = direction
    @options = options
  end

  erb_template <<~ERB
    <%= link_to href, class: class_names('pagination__link', 'pagination__link-active': active), **options do %>
      <div class="flex items-center gap-2">
        <% if icon_path %>
          <%= render Ui::Icon::Component.new(icon_path: icon_path, class: icon_classes) %>
        <% end %>
        <%= @title %>
      </div>
    <% end %>
  ERB

  private

  def icon_classes
    class_names(
      "pagination__icon",
      "pagination__icon-left": @direction == :left,
      "pagination__icon-right": @direction == :right
    )
  end
end
class Ui::Tabs::ItemComponent < ApplicationComponent
  def initialize(title:, href:, icon_path: nil, active: false, **options)
    @title = title
    @href = href
    @icon_path = icon_path
    @active = active
    @options = options
  end

  erb_template <<~ERB
    <%= link_to @href, class: class_names('tabs__link', 'tabs__link-active': @active), **@options do %>
      <div class="flex items-center gap-2 w-max">
        <% if @icon_path %>
          <%= render Ui::Icon::Component.new(path: @icon_path, class: "w-4 h-4") %>
        <% end %>
        <%= @title %>
      </div>
    <% end %>
  ERB
end

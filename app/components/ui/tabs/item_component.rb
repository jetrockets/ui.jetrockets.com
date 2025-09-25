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
      <div class="flex items-center gap-2 w-max">
        <% if @icon %>
          <%= render Ui::Icon::Component.new(path: @icon, class: "w-4 h-4") %>
        <% end %>
        <%= @title %>
      </div>
    <% end %>
  ERB
end

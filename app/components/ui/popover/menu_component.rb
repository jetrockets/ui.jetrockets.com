class Ui::Popover::MenuComponent < ApplicationComponent
  def initialize(title:, **options)
    @title = title
    @options = options
    @options[:data] ||= {}
    @options[:data][:popover] = true
    @options[:data][:popover_target] = "menu"
  end

  erb_template <<~ERB
    <%= content_tag :div, role: "tooltip", class: "popover", **@options do %>
      <h3 class="popover__title">
        <%= @title %>
      </h3>
      <% if content %>
        <div class="px-3 py-2">
          <%= content %>
        </div>
      <% end %>
      <div data-popper-arrow></div>
    <% end %>
  ERB
end

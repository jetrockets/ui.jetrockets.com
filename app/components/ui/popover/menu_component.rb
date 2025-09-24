class Ui::Popover::MenuComponent < ApplicationComponent
  def initialize(title:, **options)
    @title = title
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: "popover", **@options do %>
      <h3 class="popover__title">
        <%= @title %>
      </h3>
      <% if content %>
        <div class="px-3 py-2">
          <%= content %>
        </div>
      <% end %>
    <% end %>
  ERB
end

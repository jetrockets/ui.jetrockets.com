class Ui::Popover::ContentComponent < ApplicationComponent
  def initialize(title: nil, **options)
    @title = title
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: "popover", data: { popover_target: "content" }, **@options do %>
      <% if @title %>
        <div class="popover__title"><%= @title %></div>
      <% end %>
      <div class="popover__body">
        <%= content %>
      </div>
    <% end %>
  ERB
end

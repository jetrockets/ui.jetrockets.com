class Ui::Popover::MenuComponent < ApplicationComponent
  def initialize(title:, offset: 10, **options)
    @title = title
    @offset = offset
    @options = options
    @options[:data] ||= {}
    @options[:data][:popover] = true
    @options[:data][:popover_target] = "menu"
    @options[:style] = " --popover-padding: #{@offset}px;"
  end

  erb_template <<~ERB
    <%= content_tag :div, role: "popover", class: "popover__wrapper", **@options do %>
      <div class="popover">
        <h3 class="popover__title">
          <%= @title %>
        </h3>
        <% if content %>
          <div class="px-3 py-2">
            <%= content %>
          </div>
        <% end %>
        <div data-popper-arrow></div>
      </div>
    <% end %>
  ERB
end

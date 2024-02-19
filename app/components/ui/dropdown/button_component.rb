class Ui::Dropdown::ButtonComponent < ApplicationComponent
  def initialize(title:, icon: true, **options)
    @title = title
    @icon = icon
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :button, data: { dropdown_toggle: "dropdown" }, type: "button", **@options do %>
      <span>
        <%= @title %>
      </span>

      <% if @icon %>
        <svg class="w-2.5 h-2.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4">
        </svg>
      <% end %>
    <% end %>
  ERB
end

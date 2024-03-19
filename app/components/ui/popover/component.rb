class Ui::Popover::Component < ApplicationComponent
  def initialize(title:, placement: "top", **options)
    @title = title
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, data: { popover: true }, role: "tooltip", class: "absolute z-10 invisible inline-block w-64 text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-sm opacity-0", **@options do %>
      <div class="px-3 py-2 bg-gray-100 border-b border-gray-200 rounded-t-lg">
        <h3 class="font-semibold text-gray-900">
          <%= @title %>
        </h3>
      </div>
      <% if content %>
        <div class="px-3 py-2">
          <%= content %>
        </div>
      <% end %>
      <div data-popper-arrow></div>
    <% end %>
  ERB
end

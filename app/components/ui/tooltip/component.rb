class Ui::Tooltip::Component < ApplicationComponent
  def initialize(title:, tooltip_success: nil, **options)
    super
    @title = title
    @tooltip_success = tooltip_success
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= content_tag :div, content %>

      <div role="tooltip" data-tooltip-target="menu" class="tooltip">
        <span data-clipboard-target="defaultText"><%= @title %></span>

        <% if @tooltip_success.present? %>
          <span data-clipboard-target="successText" class="hidden"><%= @tooltip_success %></span>
        <% end %>

        <div class="tooltip__arrow tooltip__arrow-<%= @options[:data]&.[](:placement) || 'top' %>" data-popper-arrow></div>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = { controller: "tooltip", tooltip_target: "tooltip" }.deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

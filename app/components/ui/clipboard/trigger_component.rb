class Ui::Clipboard::TriggerComponent < ApplicationComponent
  renders_one :default, Ui::Clipboard::DefaultComponent
  renders_one :success, Ui::Clipboard::SuccessComponent

  def initialize(trigger_tooltip: false, tooltip_placement: "top", tooltip_default: nil, tooltip_success: nil, **options)
    @trigger_tooltip = trigger_tooltip
    @tooltip_placement = tooltip_placement
    @tooltip_default = tooltip_default
    @tooltip_success = tooltip_success
    @options = options
    @options[:data] ||= {}
    @options[:data][:clipboard_target] = "clipboard"
  end

  erb_template <<~ERB
    <%= content_tag :div, **@options do %>
      <% if @trigger_tooltip %>
        <%= render Ui::Tooltip::Component.new(tooltip_content: @tooltip_default, data: { placement: @tooltip_placement }) do %>
          <%= default %>
        <% end %>
        <%= render Ui::Tooltip::Component.new(tooltip_content: @tooltip_success, data: { placement: @tooltip_placement }) do %>
          <%= success %>
        <% end %>
      <% else %>
        <%= default %>
        <%= success %>
      <% end %>
    <% end %>
  ERB
end

class Ui::Clipboard::TooltipComponent < ApplicationComponent
  renders_one :default, Ui::Clipboard::DefaultComponent
  renders_one :success, Ui::Clipboard::SuccessComponent

  def initialize(tooltip_placement: "top", tooltip_default: nil, tooltip_success: nil, **options)
    @tooltip_placement = tooltip_placement
    @tooltip_default = tooltip_default
    @tooltip_success = tooltip_success
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **@options do %>
      <%= render Ui::Tooltip::Component.new(tooltip_content: @tooltip_default, data: { placement: @tooltip_placement }) do %>
        <%= default %>
      <% end %>
      <%= render Ui::Tooltip::Component.new(tooltip_content: @tooltip_success, data: { placement: @tooltip_placement }) do %>
        <%= success %>
      <% end %>
    <% end %>
  ERB
end

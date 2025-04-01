class Ui::TooltipFlowbite::Component < ApplicationComponent
  def initialize(trigger:, tooltip_content:, **options)
    super()
    @trigger = trigger
    @tooltip_content = tooltip_content
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= content_tag :button, @trigger %>

      <div id="tooltip" role="tooltip" data-tooltip-target="menu" class="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg shadow-xs opacity-0 tooltip">
        <%= @tooltip_content %>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = { controller: "tooltip", tooltip_target: "tooltip" }.deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

class Ui::Tooltip::Component < ApplicationComponent
  def initialize(tooltip_content:, **options)
    super
    @tooltip_content = tooltip_content
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= content_tag :div, content %>

      <div id="tooltip" role="tooltip" data-tooltip-target="menu" class="tooltip">
        <%= @tooltip_content %>
        <div class="tooltip-arrow" data-popper-arrow></div>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = { controller: "tooltip", tooltip_target: "tooltip" }.deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

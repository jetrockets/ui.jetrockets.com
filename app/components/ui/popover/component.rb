class Ui::Popover::Component < ApplicationComponent
  def initialize(placement: :bottom, **options)
    @placement = placement
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= content %>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = {
      controller: "popover",
      popover_placement_value: @placement
    }.deep_merge(@options.fetch(:data, {}))

    @options.merge(data: data_attributes)
  end
end

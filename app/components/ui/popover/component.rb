class Ui::Popover::Component < ApplicationComponent
  renders_one :trigger, Ui::Popover::TriggerComponent
  renders_one :menu, Ui::Popover::MenuComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= trigger %>

      <%= menu %>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "popover" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

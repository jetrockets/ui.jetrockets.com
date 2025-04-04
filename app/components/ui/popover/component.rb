class Ui::Popover::Component < ApplicationComponent
  renders_one :trigger, Ui::Popover::TriggerComponent
  renders_one :menu, Ui::Popover::MenuComponent

  def initialize(**options)
    super
    @options = options
    @options[:style] = " --popover-padding: #{@options[:data][:offset] || 10}px;"
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= trigger %>

      <div data-popover data-popover-target="menu" class="popover__wrapper popover__wrapper-<%= @options[:data]&.[](:placement) || 'bottom' %>" style="<%= @options[:style] %>">
        <%= menu %>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "popover" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

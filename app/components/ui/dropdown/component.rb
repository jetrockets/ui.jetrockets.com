class Ui::Dropdown::Component < ApplicationComponent
  renders_one :trigger, Ui::Dropdown::TriggerComponent
  renders_one :menu, Ui::Dropdown::MenuComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= trigger %>

      <div class="dropdown" data-dropdown-target="menu">
        <%= menu %>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "dropdown" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

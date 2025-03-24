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
    merged_data = ({ controller: "dropdown" }).merge(@options[:data] || {})
    @options.merge(data: merged_data)
  end
end

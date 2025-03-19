class Ui::Dropdown::Component < ApplicationComponent
  renders_one :trigger, Ui::Dropdown::TriggerComponent
  renders_many :lists, Ui::Dropdown::ListComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <div data-controller="dropdown" **@options>
      <%= trigger %>

      <div class="dropdown" data-dropdown-target="menu">
        <% lists.each do |list| %>
          <%= list %>
        <% end %>
      </div>
    </div>
  ERB
end

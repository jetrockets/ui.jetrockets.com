class Ui::Dropdown::Component < ApplicationComponent
  renders_one :trigger, Ui::Dropdown::TriggerComponent
  renders_many :links, Ui::Dropdown::LinksComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <div data-controller="dropdown" **@options>
      <%= trigger %>

      <div class="dropdown" data-dropdown-target="menu">
        <ul class="dropdown__wrapper">
          <% links.each do |link| %>
            <%= link %>
          <% end %>
        </ul>
      </div>
    </div>
  ERB
end

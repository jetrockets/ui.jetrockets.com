class Ui::Dropdown::Component < ApplicationComponent
  renders_one :button
  renders_many :links, Ui::Dropdown::LinksComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <div class="relative" data-controller="dropdown" **@options>
      <%= button %>

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

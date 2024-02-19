class Ui::Dropdown::Component < ApplicationComponent
  renders_one :button, Ui::Dropdown::ButtonComponent
  renders_many :links, Ui::Dropdown::LinksComponent

  def initialize(id:, **options)
    @id = id
  end

  erb_template <<~ERB
    <%= button %>

    <div id="<%= @id %>" class="dropdown">
      <ul class="dropdown__wrapper">
        <% links.each do |link| %>
          <%= link %>
        <% end %>
      </ul>
    </div>
  ERB
end

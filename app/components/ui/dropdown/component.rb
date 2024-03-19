class Ui::Dropdown::Component < ApplicationComponent
  renders_many :links, Ui::Dropdown::LinksComponent

  def initialize(id:, **options)
    @id = id
  end

  erb_template <<~ERB
    <div id="<%= @id %>" class="dropdown">
      <% if links.any? %>
        <ul class="dropdown__wrapper">
          <% links.each do |link| %>
            <%= link %>
          <% end %>
        </ul>
      <% else %>
        <%= content %>
      <% end %>
    </div>
  ERB
end

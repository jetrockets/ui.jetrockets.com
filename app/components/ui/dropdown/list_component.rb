class Ui::Dropdown::ListComponent < ApplicationComponent
  renders_many :items, Ui::Dropdown::ItemComponent

  erb_template <<~ERB
    <ul class="dropdown__wrapper">
      <% items.each do |item| %>
        <%= item %>
      <% end %>
    </ul>
  ERB
end

class Ui::Table::Tr::Component < ApplicationComponent
  renders_many :tds, Ui::Table::Td::Component
  renders_many :ths, Ui::Table::Th::Component

  erb_template <<~ERB
    <tr>
      <% ths.each do |th| %>
        <%= th %>
      <% end %>
      <% tds.each do |td| %>
        <%= td %>
      <% end %>
    </tr>
  ERB
end

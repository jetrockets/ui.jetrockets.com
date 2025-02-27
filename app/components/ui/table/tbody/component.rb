class Ui::Table::Tbody::Component < ApplicationComponent
  renders_many :trs, Ui::Table::Tr::Component

  erb_template <<~ERB
    <tbody>
      <% trs.each do |tr| %>
        <%= tr %>
      <% end %>
    </tbody>
  ERB
end

class Ui::Table::Tfoot::Component < ApplicationComponent
  renders_many :trs, Ui::Table::Tr::Component

  erb_template <<~ERB
    <tfoot>
      <% trs.each do |tr| %>
        <%= tr %>
      <% end %>
    </tfoot>
  ERB
end

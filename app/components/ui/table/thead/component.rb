class Ui::Table::Thead::Component < ApplicationComponent
  renders_many :trs, Ui::Table::Tr::Component

  erb_template <<~ERB
    <thead>
      <% trs.each do |tr| %>
        <%= tr %>
      <% end %>
    </thead>
  ERB
end

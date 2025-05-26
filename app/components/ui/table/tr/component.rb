class Ui::Table::Tr::Component < ApplicationComponent
  renders_many :tds, Ui::Table::Td::Component
  renders_many :ths, Ui::Table::Th::Component

  def initialize(**options)
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :tr, **@options do %>
      <% ths.each do |th| %>
        <%= th %>
      <% end %>
      <% tds.each do |td| %>
        <%= td %>
      <% end %>
    <% end %>
  ERB
end

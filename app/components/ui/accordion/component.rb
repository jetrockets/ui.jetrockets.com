class Ui::Accordion::Component < ApplicationComponent
  renders_many :items, Ui::Accordion::ItemComponent

  erb_template <<~ERB
    <div class="accordion" data-accordion="collapse" data-active-classes="bg-gray-50">
      <% items.each do |item| %>
        <%= item %>
      <% end %>
    </div>
  ERB
end

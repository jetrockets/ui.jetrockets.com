class Ui::Tabs::Component < ApplicationComponent
  renders_many :items, "Ui::Tabs::ItemComponent"

  def initialize(**options)
    @options = options
  end

  erb_template <<~ERB
    <div class="tabs">
      <div class="tabs__container">
        <ul class="tabs__list">
          <% items.each do |item| %>
            <li class="tabs__item">
              <%= item %>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
  ERB
end
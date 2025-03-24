class Ui::Accordion::Component < ApplicationComponent
  renders_many :items, Ui::Accordion::ItemComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <div data-controller="accordion" **@options>
      <div class="accordion" data-accordion="collapse" data-accordion-target="accordion">
        <% items.each do |item| %>
          <%= item %>
        <% end %>
      </div>
    </div
  ERB
end

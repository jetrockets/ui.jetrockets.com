class Ui::Accordion::Component < ApplicationComponent
  renders_many :items, Ui::Accordion::ItemComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <div class="accordion" data-accordion="collapse">
        <% items.each do |item| %>
          <%= item %>
        <% end %>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "accordion" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

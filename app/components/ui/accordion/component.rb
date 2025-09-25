class Ui::Accordion::Component < ApplicationComponent
  renders_many :items, "ItemComponent"

  def initialize(name: nil, **options)
    super
    @name = name
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: classes, **@options do %>
      <% items.each do |item| %>
        <%= item %>
      <% end %>
    <% end %>
  ERB

  class ItemComponent < ApplicationComponent
    def initialize(name:, title: nil, open: false)
      @name = name
      @title = title
      @open = open
    end

    erb_template <<~ERB
      <details class="accordion__details" name="<%= @name %>" open="<%= @open %>">
        <summary class="accordion__summary">
          <%= @title %>
          <%= helpers.vite_icon_tag('chevron-down.svg', class: 'accordion__icon') %>
        </summary>
        <div class="accordion__body">
          <%= content %>
        </div>
      </details>
    ERB
  end

  private

  def classes
    class_names("accordion", @options.delete(:class))
  end
end

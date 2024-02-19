class Ui::Dropdown::LinksComponent < ApplicationComponent
  def initialize(name:, href: nil, **options)
    @name = name
    @href = href
    @options = options
  end

  erb_template <<~ERB
    <li class="dropdown__item">
      <% if @href %>
        <%= link_to @name, @href, class: "dropdown__link", **@options %>
      <% else %>
        <strong class="dropdown__title">
          <%= @name %>
        </strong>
      <% end %>
    </li>
  ERB
end

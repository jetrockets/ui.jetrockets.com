class Ui::Tabs::ItemComponent < ApplicationComponent
  def initialize(title:, id:, **options)
    @title = title
    @id = id
    @options = options
  end

  erb_template <<~ERB
    <a class="tabs__link" id="<%= @id %>-tab" href="#<%= @id %>">
      <%= @title %>
    </a>
  ERB
end
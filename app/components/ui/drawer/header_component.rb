class Ui::Drawer::HeaderComponent < ApplicationComponent
  def initialize(title: nil, subtitle: nil, closable: true, id: nil, bordered: true, **options)
    @title = title
    @subtitle = subtitle
    @closable = closable
    @id = id
    @bordered = bordered
    @options = options
  end

  erb_template <<~ERB
    <div class="<%= classes %>">
      <div>
        <% if @title %>
          <h3 class="drawer__title"><%= @title %></h3>
        <% end %>
        <% if @subtitle %>
          <div class="drawer__subtitle"><%= @subtitle %></div>
        <% end %>
        <%= content %>
      </div>

      <% if @closable %>
        <button type="button" class="drawer__close" data-action="click->drawer#close click->drawers#close" aria-label="Close" data-id="<%= @id %>">
          <%= helpers.icon_tag "close", size: 6 %>
        </button>
      <% end %>
    </div>
  ERB

  private

  def classes
    class_names(
      "drawer__header",
      { "drawer__header-bordered": @bordered },
      @options.delete(:class)
    )
  end
end

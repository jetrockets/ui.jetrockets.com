class Ui::Dialog::HeaderComponent < ApplicationComponent
  def initialize(title: nil, subtitle: nil, closable: true, bordered: true, **options)
    @title = title
    @subtitle = subtitle
    @closable = closable
    @bordered = bordered
    @options = options
  end

  erb_template <<~ERB
    <div class="<%= classes %>">
      <div>
        <% if @title %>
          <h3 class="dialog__title"><%= @title %></h3>
        <% end %>
        <% if @subtitle %>
          <div class="dialog__subtitle"><%= @subtitle %></div>
        <% end %>
        <%= content %>
      </div>

      <% if @closable %>
        <button type="button" class="dialog__close" data-action="click->dialog#close" aria-label="Close">
          <%= helpers.ui.icon "x-mark", size: 6 %>
        </button>
      <% end %>
    </div>
  ERB

  private

  def classes
    class_names(
      "dialog__header",
      { "dialog__header-bordered": @bordered },
      @options.delete(:class)
    )
  end
end

class Ui::Sidebar::LinkComponent < ApplicationComponent
  def initialize(url: nil, disabled: false, active: nil, **options)
    @url = url
    @disabled = disabled
    @active = active
    @options = options
  end

  erb_template <<~ERB
    <li>
      <% if @disabled %>
        <span class="<%= classes %>"><%= content %></span>
      <% else %>
        <%= link_to @url, class: classes, **@options.except(:class) do %>
          <%= content %>
        <% end %>
      <% end %>
    </li>
  ERB

  private

  def classes
    class_names(
      "sidebar__link",
      { "sidebar__link-active": active? },
      { "sidebar__link-disabled": @disabled },
      @options[:class]
    )
  end

  def active?
    return @active unless @active.nil?
    return false if @url.nil? || @disabled

    helpers.current_page?(@url)
  end
end

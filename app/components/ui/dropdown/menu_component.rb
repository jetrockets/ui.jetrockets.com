class Ui::Dropdown::MenuComponent < ApplicationComponent
  renders_one :title
  renders_many :elements, types: {
    link: Ui::Dropdown::LinkComponent,
    item: Ui::Dropdown::ItemComponent,
    divider: Ui::Dropdown::DividerComponent
  }

  erb_template <<~ERB
    <%= title_content %>
    <ul class="<%= classes %>">
      <% elements.each do |element| %>
        <%= element %>
      <% end %>
    </ul>
  ERB

  private

  def title_content
    content_tag :h6, title, class: "dropdown__title" if title?
  end

  def classes
    class_names(
      "dropdown__wrapper",
      @options.delete(:class)
    )
  end
end

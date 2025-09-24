class Ui::Accordion::ItemComponent < ApplicationComponent
  def initialize(id:, title: nil, opened: false, **options)
    @id = id
    @title = title
    @opened = opened
    @options = options
    @options[:data] ||= {}
    @options[:data][:accordion_target] = "item"
  end

  erb_template <<~ERB
    <button type="button" class="<%= class_names('accordion__header', 'bg-gray-50': @opened) %>" data-accordion-target="trigger" data-accordion-id="<%= @id %>" aria-expanded="<%= @opened %>">
      <span>
        <%= @title %>
      </span>

      <%= helpers.vite_svg_tag('images/icons/chevron-up.svg', class: 'w-3 h-3 transition-transform duration-300 shrink-0', data: { accordion_icon: true }, aria: { hidden: true }) %>
    </button>

    <%= item %>
  ERB

  private

  def item
    content_tag :div, content, class: classes, id: "accordion_#{@id}", **@options
  end

  def classes
    class_names(
      "accordion__body",
      @options.delete(:class),
      "hidden": !@opened
    )
  end
end

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
    <button type="button" class="accordion__header" data-accordion-target="trigger" data-accordion-id="<%= @id %>" aria-expanded="<%= @opened %>">
      <span>
        <%= @title %>
      </span>
      <svg width="20px" data-accordion-icon class="w-3 h-3 transition-transform duration-300 shrink-0" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5 5 1 1 5"/>
      </svg>
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

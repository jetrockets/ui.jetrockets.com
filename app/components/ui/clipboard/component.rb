class Ui::Clipboard::Component < ApplicationComponent
  renders_one :default, Ui::Clipboard::DefaultComponent
  renders_one :success, Ui::Clipboard::SuccessComponent

  TYPES = %i[input textContent innerHTML]
  DEFAULT_TYPE = :input

  def initialize(label: nil, value_content: nil, content_type: DEFAULT_TYPE, **options)
    super
    @label = label
    @value_content = value_content
    @content_type = content_type
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <label for="clipboard" <%= "class='sr-only'" if !@label %>><%= @label %></label>
      <div class="clipboard">
        <input id="clipboard" type="text" data-clipboard-target="content" class="clipboard__input <%= 'hidden' if @content_type != :input %>" value="<%= @value_content %>" disabled readonly>

        <% if @content_type == :textContent %>
          <span><%= @value_content %></span>
        <% elsif @content_type == :innerHTML %>
          <div><%= @value_content %></div>
        <% end %>

        <button data-clipboard-target="clipboard" class="btn btn-primary">
          <%= default %>
          <%= success %>
        </button>
      </div>
    <% end %>
  ERB

  private

  def attrs
    @options.merge(data: { controller: "clipboard" })
  end
end

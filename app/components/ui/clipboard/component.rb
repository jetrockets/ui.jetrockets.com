class Ui::Clipboard::Component < ApplicationComponent
  renders_one :default, Ui::Clipboard::DefaultComponent
  renders_one :success, Ui::Clipboard::SuccessComponent

  def initialize(label: nil, value_content: nil, **options)
    super
    @label = label
    @value_content = value_content
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <label for="clipboard" <%= "class='sr-only'" if !@label %>><%= @label %></label>
      <div class="clipboard">
        <input id="clipboard" type="text" data-clipboard-target="input" class="clipboard__input" value="<%= @value_content %>" disabled readonly>
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

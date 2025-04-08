class Ui::Clipboard::Component < ApplicationComponent
  renders_one :trigger, Ui::Clipboard::TriggerComponent

  TYPES = %i[input innerHTML]
  DEFAULT_TYPE = :input

  def initialize(label: nil, value_content: nil, content_type: DEFAULT_TYPE, id: "clipboard", **options)
    super
    @label = label
    @value_content = value_content
    @content_type = content_type
    @id = id
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <label for="<%= @id %>" class="form__label<%= 'sr-only' if !@label %>"><%= @label %></label>
      <div class="clipboard">
        <input id="<%= @id %>" type="text" data-clipboard-target="content" class="max-w-80 form__input" value="<%= @value_content %>" disabled readonly <%= 'hidden' if @content_type != :input %>>
        <%= trigger %>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "clipboard" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

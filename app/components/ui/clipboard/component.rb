class Ui::Clipboard::Component < ApplicationComponent
  renders_one :trigger, Ui::Clipboard::TriggerComponent

  TYPES = %i[input innerHTML]
  DEFAULT_TYPE = :input

  def initialize(value: nil, id:, **options)
    super
    @value = value
    @id = id
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: "clipboard", **attrs do %>
      <input id="<%= @id %>" type="text" data-clipboard-target="content" class="max-w-80 form__field" value="<%= @value %>" disabled readonly hidden>
      <%= trigger %>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "clipboard" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

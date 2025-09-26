class Ui::Clipboard::TriggerComponent < ApplicationComponent
  def initialize(default:, success:, tooltip_default: nil, tooltip_success: nil, tooltip_placement: "top", **options)
    @default = default
    @success = success
    @tooltip_default = tooltip_default
    @tooltip_success = tooltip_success
    @tooltip_placement = tooltip_placement
    @options = options

    @options[:data] ||= {}
    @options[:data][:clipboard_target] = "clipboard"
  end

  erb_template <<~ERB
    <% trigger_content = capture do %>
      <%= content_tag :div, class: classes, **@options do %>
        <span data-clipboard-target="default"><%= @default.is_a?(String) ? @default : render(@default) %></span>
        <span data-clipboard-target="success" class="hidden"><%= @success.is_a?(String) ? @success : render(@success) %></span>
      <% end %>
    <% end %>

    <% if @tooltip_default.present? && @tooltip_success.present? %>
      <%= render Ui::Tooltip::Component.new(title: @tooltip_default, tooltip_success: @tooltip_success, data: { placement: @tooltip_placement }) do %>
        <%= trigger_content %>
      <% end %>
    <% else %>
      <%= trigger_content %>
    <% end %>
  ERB

  private

  def classes
    class_names("cursor-pointer", @options.delete(:class))
  end
end

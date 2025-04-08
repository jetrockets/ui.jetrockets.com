class Ui::Clipboard::TriggerComponent < ApplicationComponent
  renders_one :trigger, types: {
    empty: Ui::Clipboard::EmptyComponent,
    tooltip: Ui::Clipboard::TooltipComponent
  }

  def initialize(**options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:clipboard_target] = "clipboard"
  end

  erb_template <<~ERB
    <%= content_tag :div, **@options do %>
      <%= trigger %>
    <% end %>
  ERB
end

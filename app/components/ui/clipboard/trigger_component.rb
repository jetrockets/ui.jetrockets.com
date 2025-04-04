class Ui::Clipboard::TriggerComponent < ApplicationComponent
  renders_one :default, Ui::Clipboard::DefaultComponent
  renders_one :success, Ui::Clipboard::SuccessComponent

  def initialize(**options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:clipboard_target] = "clipboard"
  end

  erb_template <<~ERB
    <%= content_tag :div, **@options do %>
      <%= default %>
      <%= success %>
    <% end %>
  ERB
end

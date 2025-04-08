class Ui::Clipboard::EmptyComponent < ApplicationComponent
  renders_one :default, Ui::Clipboard::DefaultComponent
  renders_one :success, Ui::Clipboard::SuccessComponent

  def initialize(**options)
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **@options do %>
      <%= default %>
      <%= success %>
    <% end %>
  ERB
end

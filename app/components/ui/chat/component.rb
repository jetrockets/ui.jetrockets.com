class Ui::Chat::Component < ApplicationComponent
  def initialize(streams: [], current_user: nil, **options)
    @streams = Array(streams)
    @current_user = current_user
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: classes, **attrs do %>
      <% if @streams.any? %><%= helpers.turbo_stream_from(*@streams) %><% end %>
      <%= content %>
    <% end %>
  ERB

  private

  def attrs
    @options.merge(data: data_attributes)
  end

  # `current_user` lets the controller align messages in the browser, so a
  # realtime broadcast can send one neutral rendering to every recipient.
  def data_attributes
    attributes = { controller: "chat" }
    attributes[:chat_current_user_id_value] = @current_user.id if @current_user

    attributes.deep_merge(@options.fetch(:data, {}))
  end

  def classes
    class_names(
      "chat",
      @options.delete(:class)
    )
  end
end

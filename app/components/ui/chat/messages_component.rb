class Ui::Chat::MessagesComponent < ApplicationComponent
  def initialize(id: "chat_messages", **options)
    @id = id
    @options = options
    @options[:data] ||= {}
    @options[:data][:chat_target] = "messages"
  end

  def call
    content_tag :div, content, id: @id, class: classes, **@options
  end

  private

  def classes
    class_names(
      "chat__messages",
      @options.delete(:class)
    )
  end
end

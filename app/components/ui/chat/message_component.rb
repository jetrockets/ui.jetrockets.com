class Ui::Chat::MessageComponent < ApplicationComponent
  POSITIONS = %i[start end]
  DEFAULT_POSITION = :start

  def initialize(position: DEFAULT_POSITION, user_id: nil, **options)
    @position = POSITIONS.include?(position) ? position : DEFAULT_POSITION
    @user_id = user_id
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **attrs
  end

  private

  # With `user_id` the chat controller decides the side in the browser, which
  # keeps the markup identical for every recipient of a broadcast.
  def attrs
    return @options unless @user_id

    @options.merge(data: { user_id: @user_id }.deep_merge(@options.fetch(:data, {})))
  end

  def classes
    class_names(
      "chat__message",
      "chat__message-#{@position}",
      @options.delete(:class)
    )
  end
end

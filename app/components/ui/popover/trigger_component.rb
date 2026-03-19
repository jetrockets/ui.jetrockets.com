class Ui::Popover::TriggerComponent < ApplicationComponent
  def initialize(as: nil, **options)
    @as = as
    @options = options
  end

  def call
    if @as
      helpers.ui.public_send(@as, **@options) { content }
    else
      content_tag :span, content, **@options
    end
  end
end

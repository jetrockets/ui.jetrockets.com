class Ui::Popover::TriggerComponent < ApplicationComponent
  def initialize(**options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:popover_target] = "trigger"
  end

  def call
    content_tag :div, content, **@options
  end
end

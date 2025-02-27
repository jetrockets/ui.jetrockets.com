class Ui::Dropdown::TriggerComponent < ApplicationComponent
  def initialize(**options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:dropdown_target] = "trigger"
  end

  def call
    content_tag :button, content, **@options
  end
end

class Ui::Dropdown::TriggerComponent < ApplicationComponent
  def initialize(placement: nil, triggerType: nil, offsetSkidding: nil, offsetDistance: nil, delay: nil, ignoreClickOutsideClass: nil, **options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:dropdown_attributes] = placement, triggerType, offsetSkidding, offsetDistance, delay, ignoreClickOutsideClass
    @options[:data][:dropdown_target] = "trigger"
  end

  def call
    content_tag :button, content, **@options
  end
end

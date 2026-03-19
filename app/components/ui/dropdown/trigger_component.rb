class Ui::Dropdown::TriggerComponent < ApplicationComponent
  def initialize(as: nil, **options)
    @as = as
    @options = options
    @options[:data] ||= {}
    @options[:data][:dropdown_target] = "trigger"
  end

  def call
    if @as
      render_as_component
    else
      content_tag :span, content, role: :button, class: classes, **@options
    end
  end

  private

  def render_as_component
    helpers.ui.public_send(@as, **@options) { content }
  end

  def classes
    class_names(
      "dropdown_trigger",
      @options.delete(:class)
    )
  end
end

class Ui::Dropdown::TriggerComponent < ApplicationComponent
  def initialize(**options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:dropdown_target] = "trigger"
  end

  def call
    content_tag :span, content, role: :button, class: classses, **@options
  end

  private

  def classses
    class_names(
      "dropdown__trigger",
      @options.delete(:class)
    )
  end
end

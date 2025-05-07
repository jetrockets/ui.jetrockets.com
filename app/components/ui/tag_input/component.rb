class Ui::TagInput::Component < ApplicationComponent
  def initialize(placeholder: nil, value: nil, **options)
    @placeholder = placeholder
    @value = value
    @options = options
  end

  def call
    tag.input(type: "text", value: @value, placeholder: @placeholder, class: input_classes, **attrs)
  end

  private

  def attrs
    data_attributes = ({ controller: "tagify" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end

  def input_classes
    class_names(
      "tagify-input w-1/2 border border-gray-300 rounded px-3 py-2",
      @options.delete(:class)
    )
  end
end

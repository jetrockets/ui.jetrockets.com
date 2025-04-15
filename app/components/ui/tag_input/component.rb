class Ui::TagInput::Component < ApplicationComponent
  def initialize(placeholder: nil, value: nil, whitelist: [], **options)
    @placeholder = placeholder
    @value = value
    @whitelist = whitelist
    @options = options
  end

  def call
      tag.input(
        type: "text",
        value: @value,
        placeholder: @placeholder,
        data: {
          tagify_target: "input"
        },
        class: "tagify-input w-full border border-gray-300 rounded px-3 py-2",
        **attrs
      )
  end

  private

  def attrs
    data_attributes = ({ controller: "tagify", whitelist: @whitelist.join(",") }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

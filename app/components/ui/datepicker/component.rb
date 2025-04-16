# frozen_string_literal: true

class Ui::Datepicker::Component < ApplicationComponent
  def initialize(value: nil, placeholder: nil, id: "input_picker", **options)
    super
    @value = value
    @placeholder = placeholder
    @id = id
    @options = options
  end

  def call
    tag.input(type: "text", value: @value, placeholder: @placeholder, id: @id, class: "form__input w-1/2", **attrs)
  end

  private

  def attrs
    data_attributes = ({ controller: "datepicker" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

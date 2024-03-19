class Ui::Dropdown::ButtonComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    button_tag content, **attrs
  end

  private

  def attrs
    @options.deep_merge(data: { dropdown_toggle: "dropdown" })
  end
end

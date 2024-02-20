class Ui::Dropdown::ButtonComponent < ApplicationComponent
  def initialize(title: nil, icon: true, **options)
    @title = title
    @icon = icon
    @options = options
  end

  def call
    helpers.component "ui/button", title: body, **attrs
  end

  private

  def attrs
    @options.deep_merge(data: { dropdown_toggle: "dropdown" })
  end

  def body
    @title ? @title : content
  end
end

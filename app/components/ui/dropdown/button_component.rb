class Ui::Dropdown::ButtonComponent < ApplicationComponent
  def initialize(title: nil, **options)
    super
    @title = title
    @options = options
  end

  def call
    helpers.component "ui/button", title: body, **attrs
  end

  private

  def attrs
    @options.deep_merge(data: { dropdown_target: "trigger" })
  end

  def body
    @title ? @title : content
  end
end

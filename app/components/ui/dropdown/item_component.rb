class Ui::Dropdown::ItemComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :li, content, class: "dropdown__item", **@options
  end
end

class Ui::Table::TbodyComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :tbody, content, class: @options.delete(:class), **@options
  end
end

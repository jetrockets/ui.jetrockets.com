class Ui::Table::TheadComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :thead, content, class: @options.delete(:class), **@options
  end
end

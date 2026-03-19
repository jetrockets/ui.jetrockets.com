class Ui::Table::TfootComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :tfoot, content, class: @options.delete(:class), **@options
  end
end

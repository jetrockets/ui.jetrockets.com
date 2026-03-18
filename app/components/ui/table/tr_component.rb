class Ui::Table::TrComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :tr, content, class: @options.delete(:class), **@options
  end
end

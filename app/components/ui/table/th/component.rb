class Ui::Table::Th::Component < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :th, content, **@options
  end
end

class Ui::Card::Component < ApplicationComponent
  attr_reader :title, :body, :footer
  def initialize(title: nil, body: nil, footer: nil, **options)
    @title = title
    @body = body
    @footer = footer
    @options = options
  end
end
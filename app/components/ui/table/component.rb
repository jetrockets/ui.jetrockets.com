class Ui::Table::Component < ApplicationComponent
  attr_reader :headers, :rows

  def initialize(headers: nil, rows: nil, **options)
    @headers = headers
    @rows = rows
    @options = options
  end
end
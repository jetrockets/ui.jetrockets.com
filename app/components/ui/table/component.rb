class Ui::Table::Component < ApplicationComponent
  renders_one :thead, Ui::Table::Thead::Component
  renders_one :tbody, Ui::Table::Tbody::Component
  renders_one :tfoot, Ui::Table::Tfoot::Component

  SIZES = %i[xs sm md lg]
  DEFAULT_SIZE = :md

  def initialize(bordered: false, full: true, size: DEFAULT_SIZE, **options)
    @bordered = bordered
    @full = full
    @size = size
    @options = options
  end

  private

  def classes
    class_names(
      "table",
      "table-bordered": @bordered,
      "table-full": @full,
      "table-#{@size}": @size.present?
    )
  end
end

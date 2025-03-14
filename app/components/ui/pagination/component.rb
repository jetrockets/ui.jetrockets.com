class Ui::Pagination::Component < ApplicationComponent
  renders_many :items, "Ui::Pagination::ItemComponent"

  SIZES = %i[xs sm md lg xl]
  DEFAULT_SIZE = :md

  def initialize(size: DEFAULT_SIZE, **options)
    @size = size
    @options = options
  end

  private

  def pagination_classes
    class_names(
      "pagination",
      @options.delete(:class),
      "pagination-#{@size}"
    )
  end
end

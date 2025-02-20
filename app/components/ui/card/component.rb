class Ui::Card::Component < ApplicationComponent
  renders_one :header
  renders_one :footer
  renders_one :body

  ALIGN = %i[left center right]

  def initialize( bordered: true, align: nil, **options)
    @bordered = bordered
    @align = align
    @options = options
  end

  def card_classes
    class_names(
      "card",
      ("card-bordered" if @bordered),
      "card-#{@align}",
      @options.delete(:class)
    )
  end
end
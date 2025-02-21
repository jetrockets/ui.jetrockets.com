class Ui::Card::Component < ApplicationComponent
  renders_one :header, "Ui::Card::Header"
  renders_one :footer, "Ui::Card::Footer"
  renders_one :body

  def initialize( bordered: false, **options)
    @bordered = bordered
    @options = options
  end

  def card_classes
    class_names(
      "card",
      ("card-bordered" if @bordered),
      @options.delete(:class)
    )
  end

  class Ui::Card::Header < ApplicationComponent
    def initialize(align: :left, **options)
      @align = align
      @options = options
    end

    def call
      content_tag(:div, content, class: class_names("card__header", align_class), **@options)
    end

    def align_class
      {
        left: "items-start",
        center: "items-center",
        right: "items-end"
      }[@align]
    end
  end

  class Ui::Card::Footer < ApplicationComponent
    def initialize(align: :right, **options)
      @align = align
      @options = options
    end

    def call
      content_tag(:div, content, class: class_names("card__footer", align_class), **@options)
    end

    def align_class
      {
        left: "items-start",
        center: "items-center",
        right: "items-end"
      }[@align]
    end
  end
end
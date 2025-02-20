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
    attr_reader :classes

    def initialize(classes: "card__header", **options)
      @classes = classes
      @options = options
    end

    def call
      content_tag(:div, class: class_names("card__header", @classes), **@options) do
        content
      end
    end
  end

  class Ui::Card::Footer < ApplicationComponent
    attr_reader :classes

    def initialize(classes: "card__footer", **options)
      @classes = classes
      @options = options
    end

    def call
      content_tag(:div, class: class_names("card__footer", @classes), **@options) do
        content
      end
    end
  end
end
class Ui::Pagy::Component < ApplicationComponent
  def initialize(pagy:, **options)
    @pagy = pagy
    @options = options
  end

  attr_reader :pagy

  private

  def render?
    pagy.pages > 1
  end

  def pagination_classes
    class_names(
      "pagination",
      @options.delete(:class)
    )
  end
end

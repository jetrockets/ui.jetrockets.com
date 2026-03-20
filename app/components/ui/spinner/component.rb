class Ui::Spinner::Component < ApplicationComponent
  def initialize(size: 6, **options)
    @size = size
    @options = options
  end

  def call
    helpers.ui.icon("spinner", size: @size, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "bg-center bg-no-repeat bg-cover",
      @options.delete(:class)
    )
  end
end

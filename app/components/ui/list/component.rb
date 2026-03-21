class Ui::List::Component < ApplicationComponent
  def initialize(variant: :default, **options)
    @variant = variant
    @options = options
  end

  def call
    content_tag :ul, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "list",
      @options.delete(:class),
      "list--divided": @variant == :divided
    )
  end
end

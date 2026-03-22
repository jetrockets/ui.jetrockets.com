class Ui::Stat::Component < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "border border-border rounded-lg p-6",
      @options.delete(:class)
    )
  end
end

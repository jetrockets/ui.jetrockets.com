class Ui::Card::Component < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:div, content, class: classes, **@options)
  end

  private

  def classes
    class_names(
      "border border-border bg-card text-card-foreground rounded-card overflow-clip",
      @options.delete(:class)
    )
  end
end

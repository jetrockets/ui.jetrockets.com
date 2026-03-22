class Ui::Empty::IconComponent < Ui::Icon::Component
  def call
    content_tag :div, class: classes, **@options do
      helpers.ui.icon(@name || content, size: 6)
    end
  end

  private

  def classes
    class_names(
      "flex items-center justify-center size-14 mb-4 bg-muted text-muted-foreground rounded-xl",
      @options.delete(:class)
    )
  end
end

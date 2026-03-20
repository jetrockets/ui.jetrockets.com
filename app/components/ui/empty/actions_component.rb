class Ui::Empty::ActionsComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    helpers.ui.btn_group(content, class: classes, sticky: false, **@options)
  end

  private

  def classes
    class_names(
      "mt-6",
      @options.delete(:class)
    )
  end
end

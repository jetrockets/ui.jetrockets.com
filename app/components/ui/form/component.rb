class Ui::Form::Component < ApplicationComponent
  renders_many :fields, Ui::Form::Field::Component

  def initialize(**options)
    @options = options
  end

  def call
    content_tag :div, class: classes do
      content
    end
  end

  private

  def classes
    class_names(
      "form",
      @options.delete(:class)
    )
  end
end
class Ui::Form::Input::Component < ApplicationComponent
  def initialize(size: nil, type: nil,  errored: false, **options)
    @size = size
    @type = type
    @errored = errored
    @options = options
  end

  def call
    content_tag :input, nil, type: @type, class: classes, **@options
  end

  private

  def classes
    class_names(
      "form__input",
      @options.delete(:class),
      "form__input-xs": @size == :xs,
      "form__input-sm": @size == :sm,
      "form__input-md": @size == :md,
      "form__input-lg": @size == :lg,
      "form__input-errored": @errored
    )
  end
end
class ApplicationComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(tag: nil, classes: nil, **options)
    @tag = tag || :div
    @classes = classes
    @options = options
  end

  def call
    content_tag(@tag, content, class: @classes, **@options) if @tag
  end
end

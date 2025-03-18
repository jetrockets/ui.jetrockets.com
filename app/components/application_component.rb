class ApplicationComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(cont: nil, **options)
    @cont = cont
    @options = options
  end

  def call
    @cont.html_safe
  end
end

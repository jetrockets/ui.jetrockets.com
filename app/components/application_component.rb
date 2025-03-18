class ApplicationComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(cont: nil, **options)
    @cont = cont
    @options = options
  end

  def call
    if @cont
      @cont.html_safe
    else
      @options
    end
  end
end

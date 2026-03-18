class ApplicationComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(**options)
    @options = options
  end
end

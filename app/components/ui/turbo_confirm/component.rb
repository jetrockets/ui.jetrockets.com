# frozen_string_literal: true

class Ui::TurboConfirm::Component < ApplicationComponent
  def initialize(**options)
    super
    @options = options
  end
end

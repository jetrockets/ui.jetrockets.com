# frozen_string_literal: true

class Ui::Flash::Component < ApplicationComponent
  DISMISS_AFTER = 5000
  REMOVE_DELAY = 6000
  SHOW_DELAY = 0

  protected

  def tailwind_classes_for(flash_type)
    {
      notice: "bg-green-100 border-green-300",
      success: "bg-green-100 border-green-300",
      alert: "bg-red-100 border-red-300",
      error: "bg-red-100 border-red-300"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end

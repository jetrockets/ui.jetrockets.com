class Ui::Flash::Component < ApplicationComponent
  DISMISS_AFTER = 5000
  REMOVE_DELAY = 6000
  SHOW_DELAY = 0

  protected

  def tailwind_classes_for(flash_type)
    {
      notice: "bg-green-100",
      success: "bg-green-100",
      alert: "bg-red-100",
      error: "bg-red-100"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end

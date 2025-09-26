class Ui::Flash::Component < ApplicationComponent
  DISMISS_AFTER = 8000
  REMOVE_DELAY = 9000
  SHOW_DELAY = 250

  def initialize(dismissible: true)
    super
    @dismissible = dismissible
  end

  private

  def data_attrs
    attrs = {}
    attrs[:data] = {
      controller: "flash",
      action: "turbo:morph@window->flash#connect"
    }

    if @dismissible
      attrs[:data].merge!({
        flash_dismiss_after_value: DISMISS_AFTER,
        flash_remove_delay_value: REMOVE_DELAY,
        flash_show_delay_value: SHOW_DELAY,
        transition_enter_from: "opacity-0 translate-x-1/4",
        transition_enter_to: "opacity-100 translate-x-0",
        transition_leave_from: "opacity-100 translate-x-0",
        transition_leave_to: "opacity-0 translate-x-1/4"
      })
    end

    attrs
  end

  def tailwind_classes_for(flash_type)
    {
      notice: "bg-gray-800",
      success: "bg-gray-800",
      alert: "bg-red-700",
      error: "bg-red-700"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end

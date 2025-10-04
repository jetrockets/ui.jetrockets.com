class Ui::Flash::Component < ApplicationComponent
  DISMISS_AFTER = 5000
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
        flash_show_delay_value: SHOW_DELAY
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

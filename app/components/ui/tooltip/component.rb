class Ui::Tooltip::Component < ApplicationComponent
  def initialize(**options)
    super
    @optiobns = options
  end

  def call
    content_tag :button, content, **attrs
  end

  private

  def attrs
    data_attributes = ({ controller: "tooltip", tooltip_target: "tooltip" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

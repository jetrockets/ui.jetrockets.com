class Ui::TooltipTippy::Component < ApplicationComponent
  def initialize(tooltip_content:, **options)
    super
    @tooltip_content = tooltip_content
    @optiobns = options
  end

  def call
    content_tag :button, content, **attrs
  end

  private

  def render?
    @tooltip_content.present?
  end

  def attrs
    data_attributes = ({ controller: "tooltip_tippy", content: @tooltip_content }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

class Ui::Tooltip::Component < ApplicationComponent
  def initialize(as: nil, title:, placement: :top, **options)
    @as = as
    @title = title
    @placement = placement
    @options = options
  end

  def call
    if @as
      helpers.ui.public_send(@as, **attrs) { content }
    else
      content_tag :span, content, class: "w-fit", **attrs
    end
  end

  private

  def attrs
    data_attributes = {
      controller: "tooltip",
      tooltip_content_value: @title,
      tooltip_placement_value: @placement
    }.deep_merge(@options.fetch(:data, {}))

    @options.merge(data: data_attributes)
  end
end

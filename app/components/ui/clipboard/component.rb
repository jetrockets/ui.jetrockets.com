class Ui::Clipboard::Component < ApplicationComponent
  def initialize(as: nil, value: nil, source_id: nil, success_text: "Copied!", tooltip: nil, tooltip_success: nil, tooltip_placement: "top", **options)
    @as = as
    @value = value
    @source_id = source_id
    @success_text = success_text
    @tooltip = tooltip
    @tooltip_success = tooltip_success || success_text
    @tooltip_placement = tooltip_placement
    @options = options
  end

  def call
    if @as
      helpers.ui.public_send(@as, **attrs) { content }
    else
      content_tag :span, content, class: classes, **attrs
    end
  end

  private

  def attrs
    @options.merge(data: data_attributes)
  end

  def data_attributes
    base = {
      controller: @tooltip ? "clipboard tooltip" : "clipboard",
      clipboard_success_text_value: @success_text,
      action: @tooltip ? "click->clipboard#copy clipboard:change->tooltip#updateContent" : "click->clipboard#copy"
    }

    base[:clipboard_content_value] = @value if @value
    base[:clipboard_source_id_value] = @source_id if @source_id
    base.merge!(tooltip_attributes) if @tooltip
    base.merge(@options.fetch(:data, {}))
  end

  def tooltip_attributes
    {
      tooltip_content_value: @tooltip,
      tooltip_placement_value: @tooltip_placement,
      clipboard_success_text_value: @success_text
    }
  end

  def classes
    class_names("cursor-pointer", @options.delete(:class))
  end
end

# frozen_string_literal: true

class Ui::Modal::Component < ApplicationComponent
  # If you need a drawer instead of modal, you can prepare component for that.
  # Please copy the modal component, rename it to drawer and use it the same way.
  # https://flowbite.com/docs/components/drawer/

  attr_reader :title, :subtitle

  SIZES = %w[sm md lg xl 2xl 3xl 4xl 5xl 6xl].freeze
  DEFAULT_SIZE = "2xl"

  def initialize(title: nil, subtitle: nil, size: DEFAULT_SIZE, trigger_title: nil, trigger_class: nil, async: true, **options)
    super
    @title = title
    @subtitle = subtitle
    @size = size
    @trigger_title = trigger_title
    @trigger_class = trigger_class
    @async = async
    @options = options
  end

  private

  def container_tag
    if @async
      turbo_frame_tag :modal do
        content_tag :div, id: "modalContainer", tabindex: "-1", data: { controller: "modal-async", turbo_temporary: true }, aria: { hidden: "true" }, class: "modal" do
          turbo_frame_tag :modalWindow, class: modal__container_classes do
            yield
          end
        end
      end
    else
      content_tag :div, **attrs do
        safe_join([
          tag.div(@trigger_title, data: { modal_toggle: "modalContainer", action: "click->modal#show" }, class: @trigger_class),
          tag.div(id: "modalContainer", data: { modal_target: "modalContainer" }, tabindex: "-1", aria: { hidden: "true" }, class: "modal") do
            content_tag :div, class: modal__container_classes do
              yield
            end
          end
        ])
      end
    end
  end

  def modal__container_classes
    class_names(
      "modal__container",
      "max-w-#{@size}"
    )
  end

  def attrs
    data_attributes = ({ controller: "modal" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

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
      async_container_tag do
        yield
      end
    else
      content_tag :div, **attrs do
        safe_join([
          tag.div(@trigger_title, data: { modal_toggle: "modalContainer", action: "click->modal#show" }, class: @trigger_class),
          tag.div(id: "modalContainer", data: { modal_target: "modalContainer" }, tabindex: "-1", aria: { hidden: "true" }, class: "modal") do
            content_tag :div, class: modal__window_classes do
              yield
            end
          end
        ])
      end
    end
  end

  def async_container_tag(&block)
    if helpers.turbo_frame_request?
      turbo_frame_tag :modal do
        content_tag :div, id: "modalTurbo", tabindex: "-1", data: { controller: "modal-turbo" }, class: "modal" do
          turbo_frame_tag :modalWindow, class: modal__window_classes do
            yield
          end
        end
      end
    else
      # If not using Turbo Frame (open new tab for example), we can use a regular div
      content_tag :div, class: "flex-1" do
        content_tag :div, class: modal__window_classes do
          yield
        end
      end
    end
  end

  def modal__window_classes
    class_names(
      "modal__window",
      "max-w-#{@size}"
    )
  end

  def attrs
    data_attributes = ({ controller: "modal" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

# frozen_string_literal: true

class Modal::Component < ApplicationComponent
  # If you need a drawer instead of modal, you can prepare component for that.
  # Please copy the modal component, rename it to drawer and use it the same way.
  # https://flowbite.com/docs/components/drawer/

  attr_reader :title, :subtitle

  SIZES = %w[sm md lg xl 2xl 3xl 4xl 5xl 6xl].freeze
  DEFAULT_SIZE = "2xl"

  def initialize(title: nil, subtitle: nil, size: DEFAULT_SIZE)
    super
    @title = title
    @subtitle = subtitle
    @size = size
  end

  private

  def container_tag
    if helpers.turbo_frame_request?
      turbo_frame_tag :modal do
        content_tag :div, id: "modalContainer", tabindex: "-1", data: { controller: "modal", turbo_temporary: true }, aria: { hidden: "true" }, class: "modal" do
          turbo_frame_tag :modalWindow, class: modal__container_classes do
            yield
          end
        end
      end
    else
      content_tag :div, class: "flex-1" do
        content_tag :div, class: modal__container_classes do
          yield
        end
      end
    end
  end

  def modal__container_classes
    class_names(
      "modal__container",
      "max-w-#{@size}"
    )
  end
end

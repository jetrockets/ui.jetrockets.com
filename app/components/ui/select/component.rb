class Ui::Select::Component < ApplicationComponent
  def initialize(id: "select_tag", **options)
    super
    @id = id
    @options = options
  end

  def call
    content_tag :div, **attrs do
      tag.select(id: @id, data: { select_target: "selection" })
    end
  end

  private

  def attrs
    data_attributes = ({ controller: "select" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end
end

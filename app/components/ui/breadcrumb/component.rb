class Ui::Breadcrumb::Component < ApplicationComponent
  renders_many :items, "Ui::Breadcrumb::ItemComponent"

  def initialize(bordered: false, **options)
    @bordered = bordered
    @options = options
  end

  private

  def classes
    class_names(
      "breadcrumb",
      "breadcrumb-bordered": @bordered,
    )
  end
end
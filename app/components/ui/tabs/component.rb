class Ui::Tabs::Component < ApplicationComponent
  renders_many :items, "Ui::Tabs::ItemComponent"

  def initialize(**options)
    @options = options
  end

  private

  def classes
    class_names(
      "tabs__list",
      @options.delete(:class)
    )
  end
end

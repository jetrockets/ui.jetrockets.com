class Ui::Tabs::Component < ApplicationComponent
  renders_many :items, "Ui::Tabs::ItemComponent"

  def initialize(**options)
    @options = options
  end
end
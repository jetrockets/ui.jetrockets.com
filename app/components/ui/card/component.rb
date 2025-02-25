class Ui::Card::Component < ApplicationComponent
  renders_one :header, "Ui::Card::Header::Component"
  renders_one :footer, "Ui::Card::Footer::Component"
  renders_one :body

  def initialize(**options)
    @options = options
  end

  private

  attr_reader :options
end

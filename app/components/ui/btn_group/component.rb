class Ui::BtnGroup::Component < ApplicationComponent
  renders_many :buttons, Ui::Btn::Component

  def initialize(with_gap: false, **options)
    @with_gap = with_gap
    @options = options
  end

  private

  def classes
    class_names(
      "btn_group",
      @options.delete(:class),
      "btn_group-sticky": !@with_gap
    )
  end
end

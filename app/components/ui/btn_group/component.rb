class Ui::BtnGroup::Component < ApplicationComponent
  renders_many :buttons, Ui::Btn::Component

  def initialize(with_gap: false)
    @with_gap = with_gap
  end

  private

  def classes
    class_names(
      "btn_group",
      "btn_group-sticky": !@with_gap
    )
  end
end

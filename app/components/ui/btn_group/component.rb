class Ui::BtnGroup::Component < ApplicationComponent
  renders_many :buttons, Ui::Btn::Component
end

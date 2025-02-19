class Ui::ButtonGroup::Component < ApplicationComponent
  renders_many :buttons, Ui::Button::Component

end
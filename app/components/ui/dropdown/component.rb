class Ui::Dropdown::Component < ApplicationComponent
  renders_one :trigger, Ui::Dropdown::TriggerComponent
  renders_one :menu, Ui::Dropdown::MenuComponent

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <div data-controller="dropdown" **@options>
      <%= trigger %>

      <div class="dropdown" data-dropdown-target="menu">
        <%= menu %>
      </div>
    </div>
  ERB
end

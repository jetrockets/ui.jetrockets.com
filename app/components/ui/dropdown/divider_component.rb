class Ui::Dropdown::DividerComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  erb_template <<~ERB
    <div class="dropdown__divider", **@options></div>
  ERB
end

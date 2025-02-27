class Ui::Table::Td::Component < ApplicationComponent
  def initialize(actions: false, **options)
    @actions = actions
    @options = options
  end

  def call
    content_tag :td, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "table__actions": @actions
    )
  end
end

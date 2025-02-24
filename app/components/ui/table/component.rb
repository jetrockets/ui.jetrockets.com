class Ui::Table::Component < ApplicationComponent
  renders_many :rows, "Ui::Table::Row"

  attr_reader :headers

  def initialize(headers: nil, **options)
    @headers = headers
    @options = options
  end

  class Ui::Table::Row < ApplicationComponent
    attr_reader :name, :email, :status, :created_at, :full_month, :edit_button

    def initialize(name:nil, email: nil, status: nil, created_at: nil, full_month: nil, edit_button: nil, **options)
      @name = name
      @email = email
      @status = status
      @created_at = created_at
      @full_month = full_month
      @edit_button = edit_button
      @options = options
    end
  end
end
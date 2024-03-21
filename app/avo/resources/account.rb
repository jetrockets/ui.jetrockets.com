class Avo::Resources::Account < Avo::BaseResource
  self.title = :email

  self.includes = []
  self.search = {
    query: -> { query.where("accounts.email ILIKE ?", "%#{params[:q]}%") }
  }

  def fields
    field :id, as: :id
    field :status, as: :select, enum: ::Account.statuses
    field :email, as: :text
    field :admin, as: :boolean
  end
end

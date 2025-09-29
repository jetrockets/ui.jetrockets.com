class HealthController < ActionController::Metal
  def index
    self.response_body = "#{rand(10000)} OK"
  end
end

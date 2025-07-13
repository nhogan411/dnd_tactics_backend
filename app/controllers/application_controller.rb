class ApplicationController < ActionController::API
  # Add CORS headers
  before_action :set_cors_headers

  private

  def set_cors_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
  end

  # Placeholder authentication methods
  def authenticate_user!
    # TODO: Implement authentication
    true
  end

  def current_user
    # TODO: Implement current user lookup
    @current_user ||= User.first # Temporary fallback
  end
end

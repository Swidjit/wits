class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    super
  end
end
module Authorization
  extend ActiveSupport::Concern

  private
    def require_admin
      redirect_to root_path, alert: "You are not authorized to view this page." unless Current.user&.admin?
    end
end

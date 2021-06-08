module UserType extend ActiveSupport::Concern
  def is_admin?
    self.role.name == "admin"
  end
end
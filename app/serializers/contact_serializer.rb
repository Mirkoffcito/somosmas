class ContactSerializer < CustomActiveModelSerializer
    attributes :message, :created_at, :user_id
end
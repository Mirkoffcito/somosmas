class ContactSerializer < CustomActiveModelSerializer
    attributes :message, :created_at
end
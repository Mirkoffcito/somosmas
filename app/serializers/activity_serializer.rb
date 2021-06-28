# frozen_string_literal: true

class ActivitySerializer < CustomActiveModelSerializer
  attributes :id, :name, :content, :image
end

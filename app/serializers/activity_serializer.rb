# frozen_string_literal: true

class ActivitySerializer < CustomActiveModelSerializer
  attributes :name, :content, :image
end

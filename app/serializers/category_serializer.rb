# frozen_string_literal: true

class CategorySerializer < CustomActiveModelSerializer
  attributes :name, :description, :image
end

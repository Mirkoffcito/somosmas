# frozen_string_literal: true

class SlidesSerializer < CustomActiveModelSerializer
  attributes :order, :image
  belongs_to :organization
end

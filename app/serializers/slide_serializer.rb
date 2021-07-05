# frozen_string_literal: true

class SlideSerializer < SlidesSerializer
  attributes :text

  belongs_to :organization
end

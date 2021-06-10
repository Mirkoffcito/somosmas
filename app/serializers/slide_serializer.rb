class SlideSerializer < SlidesSerializer
  attributes :text

  belongs_to :organization
end
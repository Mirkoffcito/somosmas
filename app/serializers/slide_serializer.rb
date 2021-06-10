class SlideShowSerializer < SlidesSerializer
  attributes :text

  belongs_to :organization
end

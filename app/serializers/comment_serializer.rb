# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
    attributes :content

    default_scope {order(date: :desc)}
    
end
  
# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :new_id
end
  
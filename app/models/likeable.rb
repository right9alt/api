class Likeable < ApplicationRecord
  #belongs_to
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  #has_many
end

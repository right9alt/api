module Types
  class ImageType < Types::BaseObject
    field :id, ID, null: true
    field :url, String, null: true
    # Добавьте другие поля, если необходимо
  end
end
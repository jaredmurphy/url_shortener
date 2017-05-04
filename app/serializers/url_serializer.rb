class UrlSerializer < ActiveModel::Serializer
  attributes :id, :full_link, :short_link, :access_count
end

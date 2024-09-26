class User < ApplicationRecord
  def fetch_external
    ExternalApi.new.fetch
  end
end

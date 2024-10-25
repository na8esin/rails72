class User < ApplicationRecord
  class << self
    def greet
      ExternalApi.greet
    end
  end

  def fetch_external
    ExternalApi.new.fetch
  end

  def fetch_external_with_initial_value
    greet = morning ? "Good morning" : "Hi"

    # 外部のapiにリクエストしているつもり
    ExternalApi.new(greet:).fetch
  end
end

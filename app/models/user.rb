class User < ApplicationRecord
  def fetch_external
    ExternalApi.new.fetch
  end

  def fetch_external_with_initial_value
    ExternalApi.new(greet: "Good morning").fetch
  end
end

class ExternalApi
  def initialize(greet: "good by");end

  def fetch
    "hello"
  end

  class << self
    def greet
      "good evening"
    end
  end
end

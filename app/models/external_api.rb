class ExternalApi
  def initialize(greet: "good by");end

  # 今回のサンプルにはあまり関係ないけど、
  # このメソッドはfaradayなどで、外部にリクエストする想定
  def fetch
    "hello"
  end

  class << self
    def greet
      "good evening"
    end
  end
end

class JsonWebToken
  SECRET_KEY = ENV["SECRET_KEY_BASE"]

  def self.encode payload, exp = Settings.jwt_default_exp_hours.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode token
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end

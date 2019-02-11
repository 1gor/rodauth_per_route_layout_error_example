# frozen-string-literal: true
module Rodauth
  Feature.define(:custom_password_grace_period, :CustomPasswordGracePeriod) do
extend FastGettext::Translation
    include FastGettext::Translation
    depends :password_grace_period




  end
end

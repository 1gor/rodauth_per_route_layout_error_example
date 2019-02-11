module Rodauth
  Feature.define(:custom_email_base, :CustomEmailBase) do
    extend FastGettext::Translation
    include FastGettext::Translation
    depends :email_base

    def email_from
      scope.opts[:email_from]
    end

  end
end

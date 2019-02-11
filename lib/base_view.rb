class BaseView
  # include Logging
  # include FastGettext::Translation
  # include FastGettext::TranslationMultidomain
  attr :app
  def initialize(app)
    @app = app
  end
end

module Rodauth
  # :feature_name will be the argument given to enable to
  # load the feature, :FeatureName is optional and will be used to
  # set a constant name for prettier inspect output.
  Feature.define(:custom_template_path, :CustomTemplatePath) do
extend FastGettext::Translation
include FastGettext::Translation
    depends :base

    auth_value_method :templates_dirname, 'templates'

    private

    def template_path(page)
      f=File.join(File.dirname(__FILE__),'..', templates_dirname, "#{page}.str")
      File.exists?(f) ? f : super
    end

  end
end

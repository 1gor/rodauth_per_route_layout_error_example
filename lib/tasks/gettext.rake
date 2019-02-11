#p ENV['RACK_ENV']
if ENV['RACK_ENV']!=('production' || :production)

  PROJECT_ROOT=File.join(__dir__,'..','..')  unless defined? PROJECT_ROOT

  require "gettext/tools/task"
  gem "gettext", ">= 3.0.2"


  namespace :gettext do
    def locale_path
      path = FastGettext.translation_repositories[text_domain].instance_variable_get(:@options)[:path] rescue nil
      path || File.join(PROJECT_ROOT,"locale")
    end

    def text_domain
      # if your textdomain is not 'app': require the environment before calling e.g. gettext:find OR add TEXTDOMAIN=my_domain
      (FastGettext.text_domain rescue nil) || ENV['TEXTDOMAIN'] || "app"
    end

    # do not rename, gettext_i18n_rails_js overwrites this to inject coffee + js
    def files_to_translate
      #     Dir.glob("{app,lib,config,#{locale_path}}/**/*.{rb,erb}")
      dir = Dir.glob("{#{PROJECT_ROOT},models,views,lib,conf,#{locale_path}}/**/*.{rb,erb,str}")
      #dir.each { |f| p f }
      dir
    end

    def gettext_default_options
      %w[--sort-by-msgid --no-location --no-wrap]
    end

    def gettext_msgmerge_options
      gettext_default_options
    end

    def gettext_msgcat_options
      gettext_default_options - %w[--location]
    end

    def gettext_xgettext_options
      gettext_default_options
    end

    # require "gettext_i18n_rails/haml_parser"
    # require "gettext_i18n_rails/slim_parser"

    task :setup do
      #      Rake::Task["loadenv"].invoke(:development)
      require File.join(PROJECT_ROOT,"app")
      GetText::Tools::Task.define do |task|
        task.package_name = text_domain
        task.package_version = "1.0.0"
        task.domain = text_domain
        task.po_base_directory = locale_path
        task.mo_base_directory = locale_path
        task.files = files_to_translate
        task.enable_description = false
        task.msgmerge_options = gettext_msgmerge_options
        task.msgcat_options = gettext_msgcat_options
        task.xgettext_options = gettext_xgettext_options
      end
    end

    desc "Create mo-files"
    task :pack => [:setup] do
      Rake::Task["gettext:mo:update"].invoke
    end

    desc "Update pot/po files"
    task :find => [:setup] do
      Rake::Task["gettext:po:update"].invoke
    end

    desc "add a new language"
    task :add_language, [:language] do |_, args|
      #Rake::Task["loadenv"].invoke(:development)
      language = args.language || ENV["LANGUAGE"]

      # Let's do some pre-verification of the environment.
      if language.nil?
        puts "You need to specify the language to add. Either 'LANGUAGE=eo rake gettext:add_language' or 'rake gettext:add_language[eo]'"
        next
      end

      language_path = File.join(locale_path, language)
      mkdir_p(language_path)
      Rake.application.lookup('gettext:find', _.scope).invoke
    end
  end

end

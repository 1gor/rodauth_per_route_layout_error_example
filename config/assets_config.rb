# We add the latest jquery because of upcoming fix for CSP ajax issues.
#
# Need to remove map lines from files
# - popper.min.js
#
# Groups are roughly corresponding to layouts
# module Prior::Assets
# JS_JQUERY=%w( jquery.min.js jquery-ujs.js )

# INSP_DEFAULT=%w(
# popper.min.js
# bootstrap.js
# plugins/metisMenu/jquery.metisMenu.js
# plugins/slimscroll/jquery.slimscroll.min.js
# )
# INSP_CUSTOM=%w(
# inspinia.js
# plugins/pace/pace.min.js
# )
# end

class MyApp::App
  plugin :assets,
         :css=>{
           :default=>(
             %w( bootstrap.min.css )
           )
         },
         :css_opts=>{
           :syntax => :scss,
           :style=>( (ENV['RACK_ENV'] == 'production') ? :compressed : :expanded ),
           :cache=>false
         },
         :css_compressor=>:yui,
         :sri=>false,
         :js=>{
           :default=>(
             %w( )
           )
         },
         :group_subdirs=>false, # we want to make dirs outselfes
         :js_compressor=>:closure,
         :gzip=>(ENV['RACK_ENV'] == 'production'),
         :timestamp_paths=>(ENV['RACK_ENV'] == 'production'),
         :headers=>{'Cache-Control'=>"max-age=31536000"}.freeze,
         :precompiled=>File.expand_path('../../.compiled_assets.json', __FILE__)
  compile_assets if (ENV['RACK_ENV'] == 'production')

end

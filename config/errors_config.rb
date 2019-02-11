class MyApp::App
  plugin :not_found do
    @page_title = _("Page Not Found")
    view(
      :content=>_("Sorry, but the page you are looking for has note been found. Try checking the URL for error, then hit the refresh button on your browser."),
      :layout=>"layouts/error",
      :layout_opts=>{
        :locals=>{:error_code=>"404"}
      }

    )
  end

  if ENV['RACK_ENV'] == 'development'
    plugin :exception_page
    class RodaRequest
      def assets
        exception_page_assets
        super
      end
    end
  end

  plugin :error_handler do |e|
    logger.error "Error is #{e.inspect}"
    case e
    when Sequel::DatabaseDisconnectError
      logger.error session[:reconnecting].to_i
      unless session[:reconnecting].to_i > 3
        session[:reconnecting] =+ 1
        request.redirect request.fullpath
      end
      #view(:content=>"<p>Connection error.</p>", :layout=>"layouts/error")
    when Roda::RodaPlugins::RouteCsrf::InvalidToken
      @page_title = "Invalid Security Token"
      response.status = 400
      view(:content=>"<p>An invalid security token was submitted with this request, and this request could not be processed.</p>", :layout=>"layouts/error")
    else
      $stderr.print "#{e.class}: #{e.message}\n"
      $stderr.puts e.backtrace
      if ENV['RACK_ENV'] == 'development'
        next exception_page(e, :assets=>true)
      else
        @page_title = _("Internal Server Error")
        view(
          :content=>_("There has been an error. Our developers have been notified. Please try later."),
          :layout=>"layouts/error",
          :layout_opts=>{
            :locals=>{:error_code=>"500"}
          }
        )
      end
    end
  end

end

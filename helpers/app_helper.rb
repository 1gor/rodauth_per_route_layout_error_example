module MyApp::App::Helper
  require 'securerandom'

  def js_response
    response['Content-Type']='application/javascript; charset=utf-8'
  end

  # Whether the request is an asynchronous request
  # alternative:
  # proc{r.env['HTTP_X_REQUESTED_WITH'] =~ /XMLHttpRequest/i}
  def xhr?
    request.env['HTTP_X_REQUESTED_WITH'] =~ /XMLHttpRequest/i
  end

  def foo
    "helper foo"
  end

  def bar
    "helper bar"
  end

end

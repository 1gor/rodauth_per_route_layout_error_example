class MyApp::App
  plugin :content_security_policy
  route 'home' do |r|
    r.get do
      if xhr?
        response['Content-Type']='text/javascript; charset=utf-8'
        "console.log('hi from route');"
      end
    end

  end
end

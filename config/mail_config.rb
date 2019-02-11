# coding: utf-8
# Configure mail
require 'mail'


case ENV['RACK_ENV']
when 'test'
  Mail.defaults { delivery_method :test }
else
  Mail.defaults do
    delivery_method :smtp, \
                    {
                      :address => ENV['SMTP_HOST'],
                      :port => ENV['SMTP_PORT'],
                      :domain => ENV['EMAIL_DOMAIN'],
                      :user_name => ENV['SMTP_USER'],
                      :password => ENV['SMTP_PASSWORD'],
                      :authentication => ENV['SMTP_AUTH'].to_s.to_sym,
                      :enable_starttls_auto=> false
                    }
  end

end

class MyApp::App
  opts[:email_from]="MyApp <foo@example.com>"
end

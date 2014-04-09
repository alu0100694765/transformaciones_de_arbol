#!/usr/bin/env ruby
gem 'omniauth'
gem 'omniauth-facebook'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  config = YAML.load_file 'config/config_templatefb.yml'
  provider :facebook,config['identifier'], config['secret']
end

get '/auth/:provider/callback' do
    erb "<h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>"
  end
  
  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
  
  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end
  
  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
         <a href='/logout'>Logout</a>"
  end
  
  get '/logout' do
    session[:authenticated] = false
    redirect '/'
  end
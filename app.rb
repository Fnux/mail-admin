class MailAdmin < Sinatra::Base
  register Sinatra::Reloader if CONFIG['reloader']
  register Sinatra::Namespace

  require './lib/session_helpers.rb'
  require './lib/models.rb'

  include SessionHelpers

  # Custom redirect
  def prefix_redirect(path)
    redirect(CONFIG['prefix'] + path)
  end

  # View helpers
  helpers do
    def url_for(path)
      CONFIG['prefix'] + path
    end
  end

  ### Web ###
  namespace CONFIG['prefix'] do

    get '/' do
      erb :index
    end

    post '/login' do
      if check_user(params[:email], params[:password])
        session[:user] = gen_cookie(params[:email])
        prefix_redirect '/panel/'
      else
        prefix_redirect '/'
      end
    end

    get '/logout' do
      session[:user].clear
      prefix_redirect '/'
    end

    namespace '/panel' do
      before do 
        protected!(false)
        @user = get_session_user
        @admin = is_admin?(@user)
      end

      get '/' do
        erb :'panel/index'
      end

      # Allow the standard user to change its password
      post '/password' do
        if params['current-password'].crypt('$6$' + CONFIG['salt']) == @user.password
          if params['new-password'] == params['new-password-confirmation']
            @user.update(:password => params['new-password'].crypt('$6$' + CONFIG['salt']))
          end
        end
        prefix_redirect '/panel/'
      end
    end

    namespace '/admin' do
      before do
        protected!(true)
      end

      get '/' do
        erb :'admin/index'
      end

      # Manage domains
      get '/domains' do
        @domains = Domain.all
        erb :'admin/domains'
      end

      post '/domains/create' do
        Domain.create(
          :name => params[:name]
        )
        prefix_redirect '/admin/domains'
      end

      get '/domains/edit/:id' do
        @domain = Domain[params[:id]]
        erb :'admin/domains/edit'
      end

      post '/domains/edit/:id' do
        domain = Domain[params[:id]]
        domain.update(
          :name => params[:name],
        )

        prefix_redirect '/admin/domains'
      end

      get '/domains/destroy/:id' do
        Domain[params[:id]].destroy
        prefix_redirect '/admin/domains'
      end

      # Manage users
      get '/users' do
        @users = User.all
        erb :'admin/users'
      end

      post '/users/create' do
        User.create(
          :mail => params[:mail],
          :password => params[:password].crypt('$6$' + CONFIG['salt'])
        )
        prefix_redirect '/admin/users'
      end

      get '/users/edit/:id' do
        @user = User[params[:id]]
        erb :'admin/users/edit'
      end

      post '/users/edit/:id' do
        user = User[params[:id]]
        if params[:password].empty?
          password = user.password
        else
          password = params[:password].crypt('$6$' + CONFIG['salt'])
        end

        user.update(
          :mail => params[:mail],
          :password => password
        )

        prefix_redirect '/admin/users'
      end

      get '/users/destroy/:id' do
        User[params[:id]].destroy
        prefix_redirect '/admin/users'
      end

      # Manage aliases
      get '/aliases' do
        @aliases = Alias.all
        erb :'admin/aliases'
      end

      post '/aliases/create' do
        Alias.create(
          :source => params[:source],
          :destination => params[:destination]
        )
        prefix_redirect '/admin/aliases'
      end

      get '/aliases/edit/:id' do
        @alias = Alias[params[:id]]
        erb :'admin/aliases/edit'
      end

      post '/aliases/edit/:id' do
        mailAlias = Alias[params[:id]]
        mailAlias.update(
          :source => params[:source],
          :destination => params[:destination]
        )

        prefix_redirect '/admin/aliases'
      end

      get '/aliases/destroy/:id' do
        Alias[params[:id]].destroy
        prefix_redirect '/admin/aliases'
      end
    end
  end
end

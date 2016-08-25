class MailAdmin < Sinatra::Base
    register Sinatra::Reloader if CONFIG['reloader']
    register Sinatra::Namespace

    require './lib/helpers.rb'
    require './lib/models.rb'

    include SessionHelpers

    before '/panel/*' do
      protected!(false)
      @user = session_user
      @admin = is_admin?(@user)
    end

    before '/panel/admin/*' do
      protected!(true)
    end

    #######
    # APP #
    #######

    get '/' do
       erb :index
    end

    post '/login' do
      if check_user(params[:email], params[:password])
        session[:user] = gen_cookie(params[:email])
        redirect '/panel/'
      else
        redirect '/'
      end
    end

    get '/logout' do
      session[:user].clear
      redirect '/'
    end

    namespace '/panel' do
        get '/' do
          erb :'panel/index'
        end

        post '/password' do
          if params['current-password'].crypt('$6$') == @user.password
            if params['new-password-1'] == params['new-password-2']
              @user.update(:password => params['new-password-1'].crypt('$6$'))
            end
          end
          redirect '/panel/'
        end

        namespace '/admin' do
          get '/' do
            erb :'panel/admin/index'
          end

          get '/domains' do
            @domains = Domain.all
            erb :'panel/admin/domains'
          end

          post '/domains/create' do
            Domain.create(
              :name => params[:name]
            )
            redirect '/panel/admin/domains'
          end

          get '/domains/edit/:id' do
            @domain = Domain[params[:id]]
            erb :'panel/admin/domains/edit'
          end

          post '/domains/edit/:id' do
            domain = Domain[params[:id]]
            domain.update(
              :name => params[:name],
            )

            redirect '/panel/admin/domains'
          end

          get '/domains/destroy/:id' do
            Domain[params[:id]].destroy
            redirect '/panel/admin/domains'
          end

          get '/users' do
            @users = User.all
            erb :'panel/admin/users'
          end

          post '/users/create' do
            User.create(
              :mail => params[:mail],
              :password => params[:password].crypt('$6$')
            )
            redirect 'panel/admin/users'
          end

          get '/users/edit/:id' do
            @user = User[params[:id]]
            erb :'panel/admin/users/edit'
          end

          post '/users/edit/:id' do
            user = User[params[:id]]
            if params[:password].empty?
              password = user.password
            else
              password = params[:password].crypt('$6$')
            end

            user.update(
              :mail => params[:mail],
              :password => password
            )

            redirect '/panel/admin/users'
          end

          get '/users/destroy/:id' do
            User[params[:id]].destroy
            redirect '/panel/admin/users'
          end

          get '/aliases' do
            @aliases = Alias.all
            erb :'panel/admin/aliases'
          end

          post '/aliases/create' do
            Alias.create(
              :source => params[:source],
              :destination => params[:destination]
            )
            redirect '/panel/admin/aliases'
          end

          get '/aliases/edit/:id' do
            @alias = Alias[params[:id]]
            erb :'panel/admin/aliases/edit'
          end

          post '/aliases/edit/:id' do
            mailAlias = Alias[params[:id]]
            mailAlias.update(
              :source => params[:source],
              :destination => params[:destination]
            )

            redirect '/panel/admin/aliases'
          end

          get '/aliases/destroy/:id' do
            Alias[params[:id]].destroy
            redirect '/panel/admin/aliases'
          end
        end
    end
end

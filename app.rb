class MailAdmin < Sinatra::Base
    register Sinatra::Reloader if CONFIG['reloader']
    register Sinatra::Namespace

    SESSION_COOKIE = "logged_in"

    before '/mail/*' do
        protected!
    end

    #######
    # APP #
    #######

    get '/' do
        redirect '/mail/' if authorized?
        redirect '/login'
    end

    get '/login' do
        redirect '/' if authorized?
        erb :login, :layout => nil
    end

    post '/login' do
        if params[:username] == CONFIG['admin']['id'] && \
            params[:password] == CONFIG['admin']['password']

            session[:logged] = SESSION_COOKIE
            redirect '/'
        else
            redirect '/login'
        end
    end

    get '/logout' do
        protected!
        session.clear
        redirect '/'
    end

    namespace '/mail' do
       get '/' do
           @domains = Domain.all.count
           @users = User.all.count
           @aliases = Alias.all.count
           erb :'index', :layout => :layout
       end

       ## Domains

       get '/domains' do
           @domains = Domain.all
           erb :'domains/index', :layout => :layout
       end

       get '/domains/new' do
           erb :'domains/new', :layout => :layout
       end

       post '/domains/new' do
           Domain.create(:name => params[:name])
           redirect "/domains"
       end

       get '/domains/edit/:id' do
           @domain = Domain[params[:id]]
           erb :'domains/edit', :layout => :layout
       end

       post '/domains/edit/:id' do
           domain = Domain.find(id: params[:id].to_i)
           domain.update(
           :name => params[:name]
           )
           redirect '/domains'
       end

       get '/domains/delete/:id' do
           Domain[params[:id]].destroy
           redirect '/domains'
       end

       ## Users

       get '/users' do
           @users = User.all
           erb :'users/index', :layout => :layout
       end

       get '/users/new' do
           erb :'users/new', :layout => :layout
       end

       post '/users/new' do
           password = params[:password].crypt('$6$')

           User.create(
           :mail => params[:mail],
           :password => password
           )
           redirect "/users"
       end

       get '/users/edit/:id' do
           @user = User[params[:id]]
           erb :'users/edit', :layout => :layout
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
           redirect '/users'
       end

       get '/users/delete/:id' do
           User[params[:id]].destroy
           redirect '/users'
       end

       ## Aliases

       get '/aliases' do
           @aliases = Alias.all
           erb :'aliases/index', :layout => :layout
       end

       get '/aliases/new' do
           erb :'aliases/new', :layout => :layout
       end

       post '/aliases/new' do
           forward = Alias.create(
           :source => params[:source],
           :destination => params[:destination]
           )
           redirect "/aliases"
       end

       get '/aliases/edit/:id' do
           @forward = Alias[params[:id]]
           erb :'aliases/edit', :layout => :layout
       end

       post '/aliases/edit/:id' do
           forward = Alias[params[:id]]
           forward.update(
           :source => params[:source],
           :destination => params[:destination]
           )
           redirect '/aliases'
       end

       get '/aliases/delete/:id' do
           Alias[params[:id]].destroy
           redirect '/aliases'
       end
    end

    ###########
    # HELPERS #
    ###########

    helpers do
        def protected!
            if authorized?
                true
            else
                redirect '/login'
            end
        end

        # Check if the user is logged in
        def authorized?
            if session[:logged] == SESSION_COOKIE
                true
            else
                false
            end
        end
    end

    ############
    # DATABASE #
    ############

    class Domain < Sequel::Model(:domains)
    end

    class User < Sequel::Model(:users)
    end

    class Alias < Sequel::Model(:aliases)
    end
end

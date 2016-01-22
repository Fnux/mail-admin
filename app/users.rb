get '/users' do
   @users = User.all
   erb :'users/index', :layout => :layout
end

get '/users/new' do
   erb :'users/new', :layout => :layout
end

post '/users/new' do
   #md5 = Digest::MD5.new
   #password = md5.update(params[:password])

   user = User.new(
   :mail => params[:mail]
   )
   user.save
   redirect "/users"
end

get '/users/:id' do
   @user = User.get(params[:id])
   erb :'users/edit', :layout => :layout
end

post '/users/:id' do
   user = User.get(params[:id].to_i)
   #if params[:password] == ""
   #   password = account.password
   #else
   #   md5 = Digest::MD5.new
   #   password = md5.update(params[:password])
   #end

   user.update(
   :mail => params[:mail]
   )
   redirect '/users'
end

get '/users/delete/:id' do
   User.get(params[:id].to_i).destroy
   redirect '/users'
end

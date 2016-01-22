get '/domains' do
   @domains = Domain.all
   erb :'domains/index', :layout => :layout
end

get '/domain/new' do
   erb :'domain/new', :layout => :layout
end

post '/domain/new' do
   domain = Domain.new(
   :name => params[:name]
   )
   domain.save
   redirect "/domains"
end

get '/domains/:id' do
   @domain = Domain.get(params[:id])
   erb :'domains/edit', :layout => :layout
end

post '/domains/:id' do
   domain = Domain.get(params[:id].to_i)
   domain.update(
   :name => params[:name]
   )
   redirect '/domains'
end

get '/domains/delete/:id' do
   Domain.get(params[:id].to_i).destroy
   redirect '/domains'
end

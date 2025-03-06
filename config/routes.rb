Rails.application.routes.draw do
  post '/books', to: 'books#create'
end

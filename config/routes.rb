Rails.application.routes.draw do
  get 'new', to: 'games#new'
  get 'score', to: 'games#score'

  # get 'about', to: 'pages#about'
end

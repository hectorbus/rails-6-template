Rails.application.routes.draw do

  devise_for :users,
             controllers: {sessions: 'users/sessions',
                           confirmations: 'users/confirmations',
                           passwords: 'users/passwords'},
             path: '/',
             skip: [:registrations]

  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :authenticated_root
    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end

    authenticate :user do
      # Shows all users.
      get '/users', to: 'users/registrations#index', as: :user_registrations

      # Create new users.
      get '/users/new', to: 'users/registrations#new_user', as: :new_user
      post '/users', to: 'users/registrations#create_user', as: :create_user

      # Edit page for a user profile.
      get '/users/edit', to: 'users/registrations#edit', as: :edit_profile
      match '/users', to: 'users/registrations#update', as: :update_profile, via: [:patch, :put]

      # Edit users.
      get '/users/:id/edit', to: 'users/registrations#edit_user', as: :edit_user
      match '/users/:id', to: 'users/registrations#update_user', as: :update_user, via: [:patch, :put]

      # Change password to a user
      get '/users/:id/change_user_password', to: 'users/registrations#change_user_password', as: :change_user_password
      match '/users/:id/save_user_password', to: 'users/registrations#save_user_password', as: :save_user_password, via: [:patch, :put]

      # Change own password
      get '/users/change_password', to: 'users/registrations#change_password', as: :change_password
      match '/save_password', to: 'users/registrations#save_password', as: :save_password, via: [:patch, :put]

      # Profile page for user.
      get '/users/:id', to: 'users/registrations#show', as: :user

      # Destroys a user
      delete '/users/:id', to: 'users/registrations#destroy', as: :destroy_user_registration
    end

    # Sets the language to spanish.
    get '/set_language/spanish', to: 'set_language#spanish'

    # Sets the language to english.
    get '/set_language/english', to: 'set_language#english'

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Sets the language to spanish.
  get '/set_language/spanish', to: 'set_language#spanish'

  # Sets the language to english.
  get '/set_language/english', to: 'set_language#english'

  get '/permissions/generate_seeds', to: 'permissions#generate_seeds', as: :start_generate_seeds
  get '/permissions/get_controller_actions', to: 'permissions#get_controller_actions', as: :get_controller_actions
  resources :permissions, except: [:show]
  resources :roles, except: [:show]
  get '/roles/:id/permissions', to: 'roles#permissions', as: :role_permissions
  put '/roles/:id/permission/:permission_id', to: 'roles#permission', as: :role_permission

  get '/logbook', to: 'audits#logbook_timeline', as: :logbook_timeline
  get '/logbook/details', to: 'audits#logbook_detail_table', as: :logbook_detail_table
  # Get logbooks for timeline
  get '/logbooks/', to: 'audits#get_more_logbooks', as: :get_more_logbooks
end

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'questions#index'

  get 'question/:id', to: 'questions#show', as: :question
  patch 'question/:id/vote', to: 'questions#vote', as: :vote_question
  get 'question/:id/results', to: 'questions#results', as: :results_questions

  get 'quiz/:quiz_id', to: 'quiz_questions#show', as: :quiz
  get 'quiz/:quiz_id/:n', to: 'quiz_questions#show', constraints: { n: /\d+/ }, as: :quiz_question
  patch 'quiz/:quiz_id/:n/vote', to: 'quiz_questions#vote', constraints: { n: /\d+/ }, as: :vote_quiz_question
  get 'quiz/:quiz_id/:n/results', to: 'quiz_questions#results', constraints: { n: /\d+/ }, as: :results_quiz_question
  get 'quiz/:quiz_id/results', to: 'quiz_questions#quiz_results', as: :quiz_results

  get 'about', to: 'pages#about'
  get 'ask', to: 'pages#ask'
  get 'archive', to: 'questions#archive'

  get '/:id', to: 'questions#short', constraints: { id: /\d+/ }, as: 'short_question'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

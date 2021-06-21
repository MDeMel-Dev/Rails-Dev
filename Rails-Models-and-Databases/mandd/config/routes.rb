Rails.application.routes.draw do
  root to: "main#home"

  get 'main/showtype/:jkt', to: 'main#showtype'
  resources :main, only: [:index, :show] do
    collection do
      get 'types'
    end

    

  end
end

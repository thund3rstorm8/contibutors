Rails.application.routes.draw do
  get "home" => 'apiapp#home'
  get 'download' => 'apiapp#download'
  get "result" => 'apiapp#result'
  root 'apiapp#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

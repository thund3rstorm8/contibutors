Rails.application.routes.draw do
  get "home" => 'apiapp#home'
  get 'download' => 'apiapp#download'
  get "result" => 'apiapp#result'
  get '*unmatched_route' => 'apiapp#home'
  post '*unmatched_route' => 'apiapp#home'
  put '*unmatched_route' => 'apiapp#home'
  patch '*unmatched_route' => 'apiapp#home'
  delete '*unmatched_route' => 'apiapp#home'
  root 'apiapp#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

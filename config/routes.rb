Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :gateway do
    post '/payanyway/result'               => 'payanyway#result',  as: :payanyway_result
    get '/payanyway/success/:order_id'     => 'payanyway#success', as: :payanyway_success
    get '/payanyway/fail/:order_id'        => 'payanyway#fail',    as: :payanyway_fail
  end

end

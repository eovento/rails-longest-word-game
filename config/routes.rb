Rails.application.routes.draw do
  get 'game', to: "longest_word_game#game"

  get 'score', to: "longest_word_game#score"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # generate_grid(9)
end

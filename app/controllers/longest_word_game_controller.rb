class LongestWordGameController < ApplicationController
  def game
    a = [9, 10, 11, 12, 13, 14, 15]
    @letters = generate_grid(a.sample)
    @query = params[:query] 
  end

  def score
    @letters = params[:letters]
    @query = params[:query]
    @end_time = Time.now
    @start_time = params[:start_time].to_time
    @total_time = @end_time - @start_time
    @score = 0
    included?(@letters, @query)
    compute_score(@query, @total_time)
    score_and_message(@query, @letters, @total_time)
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time - start_time }

    score_and_message = score_and_message(attempt, grid, result[:time])
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

end
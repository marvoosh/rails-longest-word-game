require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(9)
    @start = Time.now
  end

  def score
    time = params[:start].to_i - Time.now.to_i
    @guess = params[:guess].upcase
    @letters = params[:letters]
    @included = included?(@guess, @letters)
    @is_english = english_word?(@guess)
    @score = compute_score(@guess, time)
  end

  private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : (attempt.size * (1.0 - time_taken / 60.0) / 100_000).round
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end

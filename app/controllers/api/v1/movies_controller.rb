class Api::V1::MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery unless: -> { request.format.json? }

  def show
    @movie = Movie.find(params[:id])
    render json: @movie
  end

  def create
    binding.pry
  end

  private
    def movie_params
      params.require(:movie).permit(:name, :director, :studio, :poster, :year, :runtime, :description, :rating)
    end
end

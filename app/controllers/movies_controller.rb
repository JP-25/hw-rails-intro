class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # @movies = Movie.all
      # for part one
      @m_ratings = Movie.all_ratings
      # @sorting = params[:sort]
      # @movies = Movie.all.order(@sorting)
      # for part two
      # params[:ratings].nil? ? @p_t = @m_ratings : @p_t = params[:ratings].keys
      
      # @movies = Movie.where(rating: @p_t).order(@sorting)
      
      # for part three
      @sorting = params[:sort] || session[:sort]
      # implement hash for ratings
      # @final_ratings = Hash[@m_ratings.map {|rating| [rating, rating]}] || session[:ratings] || params[:ratings]
      ## order matters
      @final_ratings =  params[:ratings] || session[:ratings] || Hash[@m_ratings.map {|rating| [rating, rating]}]
      @movies = Movie.where(rating:@final_ratings.keys).order(@sorting)
      # if statement to correct sorting via sessions
      if params[:ratings] != session[:ratings] or params[:sort] != session[:sort]
        session[:ratings] = @final_ratings
        session[:sort] = @sorting
        flash.keep
        redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
      end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end
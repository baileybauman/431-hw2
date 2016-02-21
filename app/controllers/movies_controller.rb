class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:sort].present?
      @sort_by = params[:sort]
      session[:sort] = @sort_by
    else
      @sort_by = session[:sort] || []
      #redirect_to :action=> 'index', :sort => @sort_by
      #redirect_to 'Release Date', :sort => @sort_by
    end

    if params[:ratings].present?
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    else
      @ratings = session[:ratings] || {'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
      #redirect_to :action=> 'index', :sort => @sort_by, :ratings => @ratings
    end

    if !params[:ratings].present? || !params[:sort].present?
      redirect_to :action=> 'index', {:sort => @sort_by, :ratings => @ratings}

    @all_ratings = ['G','PG','PG-13','R']
    @movies = Movie.all.order(@sort_by) 

    where_list = []
    @ratings.each do |r, val|
      where_list.push(r) 
    end
    @movies = @movies.where(:rating => where_list)
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

end

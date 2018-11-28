class NeighbourhoodsController < ApplicationController
  before_action :set_neighbourhood, only: [:show, :update, :destroy]

  # GET /neighbourhoods
  def index
    # chains db query, so it waits until the end when you render @neighbourhoods
    # active record is a wrapper around db so you can write sql queries using ruby
    # eg .all gets everything from db
    @neighbourhoods = Neighbourhood.all

    # ? at end of methods denote boolean (rails convention)
    if params[:max_home_price].present?
      @neighbourhoods = @neighbourhoods.where('home_price <= ?', params[:max_home_price])
    end

    if params[:min_home_price].present?
      @neighbourhoods = @neighbourhoods.where('home_price >= ?', params[:min_home_price])
    end

    if params[:ranked_by].present?
      @neighbourhoods = @neighbourhoods.order(params[:ranked_by].to_sym => :desc)
    end

    if params[:coords].present?
      @neighbourhoods = Location.nearest_neighbourhood(params[:coords])
    end
  
    render json: @neighbourhoods
  end

  # GET /neighbourhoods/1
  def show
    render json: @neighbourhood
  end

  # POST /neighbourhoods
  def create
    @neighbourhood = Neighbourhood.new(neighbourhood_params)

    if @neighbourhood.save
      render json: @neighbourhood, status: :created, location: @neighbourhood
    else
      render json: @neighbourhood.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /neighbourhoods/1
  def update
    if @neighbourhood.update(neighbourhood_params)
      render json: @neighbourhood
    else
      render json: @neighbourhood.errors, status: :unprocessable_entity
    end
  end

  # DELETE /neighbourhoods/1
  def destroy
    @neighbourhood.destroy
  end

  # only accessible within this controller
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neighbourhood
      @neighbourhood = Neighbourhood.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def neighbourhood_params
      params.require(:neighbourhood).permit(:name, :num_businesses, :home_price)
    end
end

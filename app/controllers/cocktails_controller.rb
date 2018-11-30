class CocktailsController < ApplicationController
  def index
    @total = Cocktail.count
    if params[:query].nil?
      @cocktails = Cocktail.all
    else
      @query = params[:query]
      @cocktails = Cocktail.where("name LIKE '%#{params[:query]}%'")
    end
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @dose = Dose.new
    @review = Review.new
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    if @cocktail.save
      @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :picture_url)
  end
end

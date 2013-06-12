class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.json
  #http://localhost:3000/categories
  def index
    @categories = Category.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    if !current_user.nil?
      
      redirect_to current_user
    end    
  end

end

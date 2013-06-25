class CategoriesController < ApplicationController
  before_filter :authenticate, :only => [:index, :show]
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
      category=Category.find_by_id(params[:id])
      if !category.nil?
        current_user.skip_callbacks = true
        current_user.update_attribute(:category, category.name)
        current_user.skip_callbacks = false
        flash[:notice] = "Category #{category.name} was selected, the application will be adpted for you."              
        redirect_to current_user  
      end      
    end    
  end
  
  private
    def authenticate
      deny_access unless signed_in?
    end

end

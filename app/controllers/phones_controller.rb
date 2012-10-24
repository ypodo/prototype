class PhonesController < ApplicationController
  # GET /phones
  # GET /phones.json
  def index
    #@phones = Phone.all

    
    
  end

  # GET /phones/1
  # GET /phones/1.json
  def show
    #@phone = Phone.find(params[:id])

  end

  # GET /phones/new
  # GET /phones/new.json
  def new
    #@phone = Phone.new
    
  end

  # GET /phones/1/edit
  def edit
    #@phone = Phone.find(params[:id])
  end

  # POST /phones
  # POST /phones.json
  def create
    @phone = Phone.new(params[:phone])
    @phone.save
    redirect_to user_path(@phone.user)
    
  end

  # PUT /phones/1
  # PUT /phones/1.json
  def update
    #@phone = Phone.find(params[:id])
  end

  # DELETE /phones/1
  # DELETE /phones/1.json
  def destroy
    #@phone = Phone.find(params[:id])
    #@phone.destroy
  end
end

class ItemsController < ApplicationController
  before_action :find_item, only: [:show, :edit, :update, :destory, :add_item]



  def index
    @items = current_user.items.all

    #respond_to do |format|
    #  format.html
    #  format.xml { send_file :filename => 'mydoc.xml', :type=>"application/xml", :disposition => 'attachment' }
    #end

    respond_to do |format|
      format.html
      format.xml
    end
  end

  def import
    @item = current_user.items.find params[:item].to_i
    if @item.import(params, @item)
      redirect_to root_path, notice: "Successfull Upload"
    else
      redirect_to :back, notice: "Something went wrong"
    end
  end

  def add_item

  end

  def show
  end


  def new
    @item = current_user.items.new
  end


  def create
    @item = current_user.items.new create_params

    if @item.save!
      redirect_to @item
    else
      redirect_to :back
    end
  end

  def make

  end


  def edit
  end


  def update
    if @item.update! create_params
      redirect_to @item
    else
      redirect_to :back
    end
  end


  def destroy
    @item = Item.find params[:id]
    if @item.destroy
      redirect_to root_path
    else
      redirect_to :back
    end

  end


  private

  def find_item
    @item = current_user.items.find params[:id]
  end

  def create_params
    params.permit(:audio)
    params[:item].permit(:title, :link, :keywords, :author, :cdata, :username, :address, :password, :file_name, :audio_dir, :podcast_dir)
  end


end

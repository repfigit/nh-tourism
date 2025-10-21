class Admin::DestinationsController < Admin::BaseController
  before_action :set_destination, only: [:show, :edit, :update, :destroy]

  def index
    @destinations = Destination.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @destination = Destination.new
  end

  def create
    @destination = Destination.new(destination_params)

    if @destination.save
      redirect_to admin_destination_path(@destination), notice: 'Destination was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @destination.update(destination_params)
      redirect_to admin_destination_path(@destination), notice: 'Destination was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @destination.destroy
    redirect_to admin_destinations_path, notice: 'Destination was successfully deleted.'
  end

  private

  def set_destination
    @destination = Destination.find(params[:id])
  end

  def destination_params
    params.require(:destination).permit(:name, :location, :description, :featured, :image_url, :slug)
  end
end

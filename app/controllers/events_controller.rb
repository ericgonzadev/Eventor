class EventsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:category]
      @events =  Event.search(params).paginate(page: params[:page], per_page: 12)
    else
      @events =  Event.upcoming.paginate(page: params[:page], per_page: 12)
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    @event.category_id = params[:category_id].to_i
    if @event.save && @event.has_valid_date?
      current_user.attend(@event)
      flash[:success] = "Event Created"
      redirect_to @event
    else
      flash.now[:danger] = "Event date must be 1 or more days ahead from now" if !@event.has_valid_date?
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @category = Category.find(@event.category_id).name
    @comments = @event.comments
    @comment = Comment.new
    @hash = Gmaps4rails.build_markers(@event) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
    end
  end

  def edit
    @event = Event.find(params[:id])
    authorized?(@event)
  end

  def update
    @event = Event.find(params[:id])
    authorized?(@event)
    @event.category_id = params[:category_id].to_i
    if @event.update(event_params) && @event.has_valid_date?
      flash[:success] = "Event Updated"
      redirect_to @event
    else
      flash.now[:danger] = "Event date must be 1 or more days ahead from now" if !@event.has_valid_date?
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:success] = "Event Deleted"
    redirect_to current_user
  end

  def attendees
    @event  = Event.find(params[:id])
    @users = @event.attendees.paginate(page: params[:page])
  end

private

  def event_params
    params.require(:event).permit(:title, :description, :date, :category_id, :picture, :address, :latitude, :longitude)
  end
end

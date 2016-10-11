class AttendsController < ApplicationController
	before_action :logged_in_user

  def create
    @event = Event.find(params[:attended_event_id])
    current_user.attend(@event)
    respond_to do |format|
      format.html { redirect_to @event }
      format.js
    end
  end

  def destroy
    @event = Attend.find(params[:id]).attended_event
    current_user.unattend(@event)
    respond_to do |format|
      format.html { redirect_to @event }
      format.js
    end
  end
end

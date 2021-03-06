module Api::V1
  class EventsController < ApplicationController
    before_action :set_event, only: [:show, :update, :destroy]

    # GET api/v1/events
    def index
      @events = current_user.events

      render json: @events
    end

    # GET api/v1/events/1
    def show
      render json: @event
    end

    # POST api/v1/events
    def create
      @user = current_user
      @event = @user.events.new(event_params)
      if @event.save
        render json: @event, status: :created, location: api_v1_event_path(@event)
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT api/v1/events/1
    def update
      if @event.update(event_params)
        render json: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    # DELETE api/v1/events/1
    def destroy
      @event.destroy
      render json: I18n.t("confirms.event.success_destroyed")
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = Event.find_by(id: params[:id])

        unless @event
          render json: I18n.t("errors.event.not_found"), status: 404
        end
      end

      # Only allow a trusted parameter "white list" through.
      def event_params
        params.require(:event).permit(:name, :description, :date_start, :date_finish, :associate, :user_id)
      end
  end
end
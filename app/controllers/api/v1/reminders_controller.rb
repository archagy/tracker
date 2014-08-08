class API::V1::RemindersController < API::BaseController
  respond_to :json
  before_action :check_owner, only: [:show, :update, :destroy]

  def index
    render json: client.reminders
  end

  def show
    render json: reminder
  end

  def create
    reminder = client.reminders.create!(safe_params)
    render json: reminder
  end

  def update
    reminder.update_attributes(safe_params)
    render nothing: true
  end

  def destroy
    reminder.destroy
    render nothing: true
  end

  private
  def check_owner
    permission_denied if current_user != reminder.owner.user
  end
  def client
    @client ||= current_user.clients.find(params[:client_id])
  end
  def reminder
    @reminder ||= Reminder.find(params[:id])    
  end

  def safe_params
    params.require(:reminder).permit(:name,:description,:date,:status,:priority)
  end
end
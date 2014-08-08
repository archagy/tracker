class API::V1::ClientsController < API::BaseController
	respond_to :json
	before_action :check_owner, only: [:show, :update, :destroy]

	def index
		render json: current_user.clients
	end
	
	def show
    	render json: client
  	end

  	def create
   		client = current_user.clients.create!(safe_params)
   	 	render json: client
 	 end

  	def update
   		client.update_attributes(safe_params)
    	render nothing: true
  	end

	def destroy
    	client.destroy
    	render nothing: true
  	end

	private 

	def reminder_list
		@reminder_list ||= Reminder.find_by(client_id: params[:client_id])  
	end
	def client
		@client ||= Client.find(params[:id])
	end
	def check_owner
		permission_denied if current_user != client.user
	end
	def safe_params
    	params.require(:client).permit(:name)
  	end
end
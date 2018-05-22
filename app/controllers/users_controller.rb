class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only:[:edit, :update, :destroy] 
  before_action :require_admin, only: [:destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 5)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @user_posts = @user.microposts.paginate(:page => params[:page], :per_page => 5) 
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and All post is deleted"
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    # user restrict
    def require_same_user
      if current_user != @user and !current_user.admin?
        flash[:danger] = "You are only allowed to modify your own Profile"
        redirect_to root_path
      end
    end

    # Admin action 
    def require_admin
      if logged_in? and !current_user.admin?
        flash[:danger] = "Only Admin is allowed for this action"
        redirect_to root_path
      end
    end

end

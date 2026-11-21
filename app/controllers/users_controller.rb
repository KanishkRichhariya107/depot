class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.order(:name)
  end

  def orders
    @orders = Current.user.orders
  end

  def line_items
    @per_page = 5
    @page = [ params[:page].to_i, 1 ].max

    line_items = Current.user.line_items.includes(:product, :order).order(created_at: :desc, id: :desc)
    @total_count = line_items.count
    @total_pages = (@total_count.to_f / @per_page).ceil
    @line_items = line_items.limit(@per_page).offset((@page - 1) * @per_page)
  end
  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User #{@user.name} was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end
rescue_from "User::Error" do |exception|
  redirect_to users_url, notice: exception.message
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :name, :email_address, :password, :password_confirmation ])
    end
end

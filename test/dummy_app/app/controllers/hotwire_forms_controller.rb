class HotwireFormsController < ActionController::Base
  layout "application"

  def show
    @user = User.new(session[:user])
  end

  # GET /users/new
  def new
    @user = User.new(params[:user]&.permit!)

    render 'form'
  end

  # GET /users/1/edit
  def edit
    @user = User.new(name: "Yuki Nishijima")

    render 'form'
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.valid?
      session[:user] = user_params
      redirect_to hotwire_form_path(1)
    else
      render 'form', status: 422
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = User.new(user_params)

    render(@user.valid? ? 'show' : 'form')
  end

  private

  def user_params
    params.require(:user).permit!
  end
end

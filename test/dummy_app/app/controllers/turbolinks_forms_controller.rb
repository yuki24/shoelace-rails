class TurbolinksFormsController < ActionController::Base
  layout "application"

  # GET /users/new
  def new
    @user = User.new

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

    render(@user.valid? ? 'show' : 'form')
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

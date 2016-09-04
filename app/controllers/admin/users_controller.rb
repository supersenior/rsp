class Admin::UsersController < AdminController
  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    flash[:notice] = "Impersonating #{user.email}"
    redirect_to projects_path
  end

  def stop_impersonating
    stop_impersonating_user
    flash[:notice] = "Stopped impersonating user"
    redirect_to admin_path
  end
end

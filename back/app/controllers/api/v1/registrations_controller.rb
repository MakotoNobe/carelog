class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:name, :email, :password, :password_confirmation, :phone_number, :post_code, :address)
  end
  # ストロングパラメーターの追記
end

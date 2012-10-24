require 'test_helper'

class RecipientPhonesControllerTest < ActionController::TestCase
  setup do
    @recipient_phone = recipient_phones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recipient_phones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recipient_phone" do
    assert_difference('RecipientPhone.count') do
      post :create, recipient_phone: { Mail: @recipient_phone.Mail, Name: @recipient_phone.Name, phone: @recipient_phone.phone, returned: @recipient_phone.returned }
    end

    assert_redirected_to recipient_phone_path(assigns(:recipient_phone))
  end

  test "should show recipient_phone" do
    get :show, id: @recipient_phone
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recipient_phone
    assert_response :success
  end

  test "should update recipient_phone" do
    put :update, id: @recipient_phone, recipient_phone: { Mail: @recipient_phone.Mail, Name: @recipient_phone.Name, phone: @recipient_phone.phone, returned: @recipient_phone.returned }
    assert_redirected_to recipient_phone_path(assigns(:recipient_phone))
  end

  test "should destroy recipient_phone" do
    assert_difference('RecipientPhone.count', -1) do
      delete :destroy, id: @recipient_phone
    end

    assert_redirected_to recipient_phones_path
  end
end

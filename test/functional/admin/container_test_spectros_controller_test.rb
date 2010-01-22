require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/container_test_spectros_controller'

# Re-raise errors caught by the controller.
class Admin::ContainerTestSpectrosController; def rescue_action(e) raise e end; end

class Admin::ContainerTestSpectrosControllerTest < Test::Unit::TestCase
  fixtures :admin_container_test_spectros

  def setup
    @controller = Admin::ContainerTestSpectrosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = container_test_spectros(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:container_test_spectros)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:container_test_spectro)
    assert assigns(:container_test_spectro).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:container_test_spectro)
  end

  def test_create
    num_container_test_spectros = ContainerTestSpectro.count

    post :create, :container_test_spectro => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_container_test_spectros + 1, ContainerTestSpectro.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:container_test_spectro)
    assert assigns(:container_test_spectro).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ContainerTestSpectro.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ContainerTestSpectro.find(@first_id)
    }
  end
end

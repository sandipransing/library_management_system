require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/container_test_zetas_controller'

# Re-raise errors caught by the controller.
class Admin::ContainerTestZetasController; def rescue_action(e) raise e end; end

class Admin::ContainerTestZetasControllerTest < Test::Unit::TestCase
  fixtures :admin_container_test_zetas

  def setup
    @controller = Admin::ContainerTestZetasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = container_test_zetas(:first).id
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

    assert_not_nil assigns(:container_test_zetas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:container_test_zeta)
    assert assigns(:container_test_zeta).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:container_test_zeta)
  end

  def test_create
    num_container_test_zetas = ContainerTestZeta.count

    post :create, :container_test_zeta => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_container_test_zetas + 1, ContainerTestZeta.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:container_test_zeta)
    assert assigns(:container_test_zeta).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ContainerTestZeta.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ContainerTestZeta.find(@first_id)
    }
  end
end

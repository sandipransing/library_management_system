require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/container_test_petries_controller'

# Re-raise errors caught by the controller.
class Admin::ContainerTestPetriesController; def rescue_action(e) raise e end; end

class Admin::ContainerTestPetriesControllerTest < Test::Unit::TestCase
  fixtures :admin_container_test_petries

  def setup
    @controller = Admin::ContainerTestPetriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = container_test_petries(:first).id
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

    assert_not_nil assigns(:container_test_petries)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:container_test_petry)
    assert assigns(:container_test_petry).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:container_test_petry)
  end

  def test_create
    num_container_test_petries = ContainerTestPetry.count

    post :create, :container_test_petry => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_container_test_petries + 1, ContainerTestPetry.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:container_test_petry)
    assert assigns(:container_test_petry).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ContainerTestPetry.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ContainerTestPetry.find(@first_id)
    }
  end
end

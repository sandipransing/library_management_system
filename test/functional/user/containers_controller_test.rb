require File.dirname(__FILE__) + '/../../test_helper'
require 'user/containers_controller'

# Re-raise errors caught by the controller.
class User::ContainersController; def rescue_action(e) raise e end; end

class User::ContainersControllerTest < Test::Unit::TestCase
  fixtures :user_containers

  def setup
    @controller = User::ContainersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = containers(:first).id
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

    assert_not_nil assigns(:containers)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:container)
    assert assigns(:container).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:container)
  end

  def test_create
    num_containers = Container.count

    post :create, :container => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_containers + 1, Container.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:container)
    assert assigns(:container).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Container.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Container.find(@first_id)
    }
  end
end

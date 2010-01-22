require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/tmp_production_containers_controller'

# Re-raise errors caught by the controller.
class Admin::TmpProductionContainersController; def rescue_action(e) raise e end; end

class Admin::TmpProductionContainersControllerTest < Test::Unit::TestCase
  fixtures :admin_tmp_production_containers

  def setup
    @controller = Admin::TmpProductionContainersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = tmp_production_containers(:first).id
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

    assert_not_nil assigns(:tmp_production_containers)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:tmp_production_container)
    assert assigns(:tmp_production_container).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:tmp_production_container)
  end

  def test_create
    num_tmp_production_containers = TmpProductionContainer.count

    post :create, :tmp_production_container => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_tmp_production_containers + 1, TmpProductionContainer.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tmp_production_container)
    assert assigns(:tmp_production_container).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      TmpProductionContainer.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TmpProductionContainer.find(@first_id)
    }
  end
end

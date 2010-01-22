require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/qualities_controller'

# Re-raise errors caught by the controller.
class Admin::QualitiesController; def rescue_action(e) raise e end; end

class Admin::QualitiesControllerTest < Test::Unit::TestCase
  fixtures :admin_qualities

  def setup
    @controller = Admin::QualitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = qualities(:first).id
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

    assert_not_nil assigns(:qualities)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:quality)
    assert assigns(:quality).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:quality)
  end

  def test_create
    num_qualities = Quality.count

    post :create, :quality => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_qualities + 1, Quality.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:quality)
    assert assigns(:quality).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Quality.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Quality.find(@first_id)
    }
  end
end

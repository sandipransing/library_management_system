require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/attachments_controller'

# Re-raise errors caught by the controller.
class Admin::AttachmentsController; def rescue_action(e) raise e end; end

class Admin::AttachmentsControllerTest < Test::Unit::TestCase
  fixtures :admin_attachments

  def setup
    @controller = Admin::AttachmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = attachments(:first).id
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

    assert_not_nil assigns(:attachments)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:attachment)
    assert assigns(:attachment).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:attachment)
  end

  def test_create
    num_attachments = Attachment.count

    post :create, :attachment => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_attachments + 1, Attachment.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:attachment)
    assert assigns(:attachment).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Attachment.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Attachment.find(@first_id)
    }
  end
end

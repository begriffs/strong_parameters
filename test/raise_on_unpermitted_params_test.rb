require 'test_helper'
require 'action_controller/parameters'

class RaiseOnUnpermittedParamsTest < ActiveSupport::TestCase
  def setup
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "raises on unexpected params" do
    params = ActionController::Parameters.new({
      :book => { :pages => 65 },
      :fishing => "Turnips"
    })

    assert_raises(ActionController::UnpermittedParameters) do
      params.permit(:book => [:pages])
    end
  end

  test "raises on unexpected nested params" do
    params = ActionController::Parameters.new({
      :book => { :pages => 65, :title => "Green Cats and where to find then." }
    })

    assert_raises(ActionController::UnpermittedParameters) do
      params.permit(:book => [:pages])
    end
  end

  test "does not raise on empty array of objects" do
    params = ActionController::Parameters.new({
      :things => [ ]
    })

    assert_nothing_raised(ActionController::UnpermittedParameters) do
      params.permit :things => [ :foo ]
    end
  end
end

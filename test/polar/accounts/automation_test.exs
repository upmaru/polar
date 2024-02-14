defmodule Polar.Accounts.AutomationTest do
  use Polar.DataCase, async: true

  alias Polar.Accounts.Automation

  describe "create_bot" do
    test "successfully create and confirm bot" do
      password = Automation.generate_password()

      assert {:ok, user} = Automation.create_bot(password)
    end
  end
end

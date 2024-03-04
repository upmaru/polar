defmodule Polar.Accounts.AutomationTest do
  use Polar.DataCase, async: true

  alias Polar.Accounts.Automation

  describe "create_bot" do
    test "successfully create and confirm bot" do
      password = Automation.generate_password()

      assert {:ok, bot} = Automation.create_bot(password)

      assert bot.email == "bot@opsmaru.com"
    end
  end
end

defmodule Polar.Machines.Check.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Machines

  describe "create check" do
    test "successfully create check" do
      assert {:ok, check} =
               Machines.create_check(%{
                 name: "ipv4 issuing",
                 description: "checks that ipv4 can be issued."
               })

      assert check.slug == "ipv4-issuing"
    end
  end
end

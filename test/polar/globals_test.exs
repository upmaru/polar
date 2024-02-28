defmodule Polar.GlobalsTest do
  use Polar.DataCase, async: true

  alias Polar.Globals.Basic

  describe "create" do
    test "can create basic setting" do
      {:ok, setting} = Polar.Globals.save("basic", %{versions_per_product: 3})

      assert setting.key == "basic"
      assert %{versions_per_product: 3} = :erlang.binary_to_term(setting.value)
    end
  end

  describe "get" do
    setup do
      {:ok, _setting} = Polar.Globals.save("basic", %{versions_per_product: 3})

      :ok
    end

    test "can get basic setting" do
      assert %Basic{versions_per_product: 3} = Polar.Globals.get("basic")
    end
  end

  describe "update" do
    setup do
      {:ok, _setting} = Polar.Globals.save("basic", %{versions_per_product: 3})

      :ok
    end

    test "can change basic setting" do
      {:ok, setting} = Polar.Globals.save("basic", %{versions_per_product: 2})

      assert %{versions_per_product: 2} = :erlang.binary_to_term(setting.value)
    end
  end
end

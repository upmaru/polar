defmodule Polar.Streams.Product.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Streams
  alias Polar.Streams.Product

  describe "get_or_create!" do
    test "can get or create product" do
      assert %Product{} =
               Streams.get_or_create_product!(%{
                 aliases: ["alpine/3.19", "alpine/3.19/default"],
                 arch: "amd64",
                 os: "Alpine",
                 release: "3.19",
                 release_title: "3.19",
                 variant: "default",
                 requirements: %{
                   secureboot: false
                 }
               })
    end
  end
end

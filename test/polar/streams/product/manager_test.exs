defmodule Polar.Streams.Product.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Accounts
  alias Polar.Streams
  alias Polar.Streams.Product

  import Polar.AccountsFixtures
  import Polar.StreamsFixtures

  setup do
    password = Accounts.generate_automation_password()

    bot = bot_fixture(%{password: password})

    {:ok, bot: bot}
  end

  describe "filter" do
    setup %{bot: bot} do
      {:ok, %Product{} = without_active_versions} =
        Streams.create_product(%{
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

      {:ok, %Product{} = with_active_versions} =
        Streams.create_product(%{
          aliases: ["alpine/3.18", "alpine/3.18/default"],
          arch: "amd64",
          os: "Alpine",
          release: "3.18",
          release_title: "3.18",
          variant: "default",
          requirements: %{
            secureboot: false
          }
        })

      {:ok, version} =
        Streams.create_version(with_active_versions, %{
          serial: "20240209_13:00",
          items: [
            %{
              name: "lxd.tar.gz",
              file_type: "lxd.tar.gz",
              hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62dd",
              size: 876,
              path: "images/alpine/edge/amd64/default/20240209_13:00/incus.tar.xz"
            },
            %{
              name: "root.squashfs",
              file_type: "squashfs",
              hash: "47cc4070da1bf17d8364c390…3603f4ed7e9e46582e690d2",
              size: 2_982_800,
              path: "images/alpine/edge/amd64/default/20240209_13:00/rootfs.tar.xz"
            }
          ]
        })

      {:ok, %{resource: testing_version}} =
        Eventful.Transit.perform(version, bot, "test")

      {:ok, %{resource: _active_version}} =
        Eventful.Transit.perform(testing_version, bot, "activate")

      {:ok,
       without_active_versions: without_active_versions,
       with_active_versions: with_active_versions}
    end

    test "filter only product with active versions", %{
      with_active_versions: with_active_versions
    } do
      assert [product] = Streams.list_products([:active])

      assert product.id == with_active_versions.id
    end
  end

  describe "get/1" do
    setup do
      {:ok, %Product{} = _product} =
        Streams.create_product(valid_product_attributes("alpine:3.19:amd64:default"))

      :ok
    end

    test "can get product" do
      assert %Product{} =
               Streams.get_product(%{
                 arch: "amd64",
                 os: "Alpine",
                 release: "3.19",
                 variant: "default"
               })
    end
  end
end

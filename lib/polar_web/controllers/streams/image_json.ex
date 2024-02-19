defmodule PolarWeb.Streams.ImageJSON do
  @doc """
  Renders product listing
  """

  alias Polar.Streams.Product

  def index(%{products: products, credential: credential}) do
    %{
      content_id: "images",
      datatype: "image-downloads",
      format: "products:1.0",
      products:
        Enum.map(products, &render_product(&1, %{credential: credential}))
        |> Enum.into(%{})
    }
  end

  defp render_product(product, params) do
    {Product.key(product), product_attributes(product, params)}
  end

  defp product_attributes(product, params) do
    %{
      aliases: Enum.join(product.aliases, ","),
      arch: product.arch,
      os: product.os,
      release: product.release,
      release_title: product.release_title,
      requirements: product.requirements,
      variant: product.variant,
      versions:
        Enum.map(product.active_versions, &render_version(&1, params))
        |> Enum.into(%{})
    }
  end

  defp render_version(version, params) do
    {version.serial, version_attributes(version, params)}
  end

  defp version_attributes(version, %{credential: credential}) do
    metadata_items =
      Enum.filter(version.items, fn item ->
        item.is_metadata
      end)

    non_metadata =
      Enum.filter(version.items, fn item ->
        not item.is_metadata
      end)

    metadata =
      Enum.find(metadata_items, fn item ->
        item.name =~ credential.type
      end)

    %{
      items:
        [metadata | non_metadata]
        |> Enum.map(&render_item/1)
        |> Enum.into(%{})
    }
  end

  defp render_item(item) do
    {item.name, item_attributes(item)}
  end

  defp item_attributes(item) do
    combined_hashes =
      item.combined_hashes
      |> Enum.map(fn combined_hash ->
        {combined_hash.name, combined_hash.hash}
      end)
      |> Enum.into(%{})

    path = "/items/#{item.id}"

    %{ftype: item.file_type, sha256: item.hash, size: item.size, path: path}
    |> Map.merge(combined_hashes)
  end
end

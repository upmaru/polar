defmodule PolarWeb.Publish.ProductJSON do
  def show(%{product: product}) do
    %{
      data: %{
        id: product.id,
        os: product.os,
        release: product.release,
        arch: product.arch,
        variant: product.variant
      }
    }
  end
end

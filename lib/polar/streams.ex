defmodule Polar.Streams do
  alias __MODULE__.Product

  defdelegate get_or_create_product!(attrs),
    to: Product.Manager,
    as: :get_or_create!

  alias __MODULE__.Version

  defdelegate create_version(product, attrs),
    to: Version.Manager,
    as: :create
end

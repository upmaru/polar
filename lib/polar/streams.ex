defmodule Polar.Streams do
  alias __MODULE__.Product

  defdelegate list_products(scopes),
    to: Product.Manager,
    as: :list

  defdelegate get_product(attrs),
    to: Product.Manager,
    as: :get

  defdelegate create_product(attrs),
    to: Product.Manager,
    as: :create

  defdelegate update_product(product, attrs),
    to: Product.Manager,
    as: :update

  alias __MODULE__.Version

  defdelegate create_version(product, attrs),
    to: Version.Manager,
    as: :create

  defdelegate deactivate_previous_versions(version),
    to: Version.Manager,
    as: :deactivate_previous

  alias __MODULE__.Item

  defdelegate record_item_access(item, space_credential),
    to: Item.Manager,
    as: :record_access
end

defmodule Polar.Streams.Item.Manager do
  alias Polar.Repo

  alias Polar.Streams.Item
  alias Polar.Accounts.Space

  import Ecto.Query, only: [from: 2]

  def record_access(%Item{id: item_id}, %Space.Credential{id: space_credential_id}) do
    Item.Access
    |> Repo.get_by(item_id: item_id, space_credential_id: space_credential_id)
    |> case do
      nil ->
        %Item.Access{
          item_id: item_id,
          space_credential_id: space_credential_id,
          count: 1
        }
        |> Repo.insert!()

      %Item.Access{id: item_access_id} = item_access ->
        from(ia in Item.Access,
          update: [inc: [count: 1]],
          where: ia.id == ^item_access_id
        )
        |> Repo.update_all([])

        Repo.reload(item_access)
    end
  end
end

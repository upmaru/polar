defmodule PolarWeb.Dashboard.DataLoader do
  alias Polar.Repo
  alias Polar.Accounts.Space

  import Ecto.Query, only: [from: 2]

  def load_spaces(user) do
    from(s in Space,
      where: s.owner_id == ^user.id,
      limit: 5,
      order_by: [desc: :updated_at]
    )
    |> Repo.all()
    |> Repo.preload([:owner])
  end
end

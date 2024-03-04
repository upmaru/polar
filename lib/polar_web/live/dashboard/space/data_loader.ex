defmodule PolarWeb.Dashboard.Space.DataLoader do
  alias Polar.Repo
  alias Polar.Accounts.Space

  import Ecto.Query, only: [from: 2]

  def load_credentials(%Space{} = space) do
    from(sc in Space.Credential,
      where:
        sc.space_id == ^space.id and
          sc.current_state == ^"active"
    )
    |> Repo.all()
  end
end

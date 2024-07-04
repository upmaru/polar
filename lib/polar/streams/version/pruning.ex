defmodule Polar.Streams.Version.Pruning do
  use Oban.Worker, queue: :default

  alias Polar.Repo
  alias Polar.Accounts.Automation
  alias Polar.Streams.Version

  import Ecto.Query, only: [from: 2]

  @age_days 2

  def perform(%Job{}) do
    age =
      DateTime.utc_now()
      |> DateTime.add(-@age_days, :day)

    versions_to_deactivate =
      from(v in Version,
        where: v.current_state == "testing" and v.inserted_at < ^age
      )
      |> Repo.all()

    bot = Automation.get_bot!()

    Enum.each(versions_to_deactivate, fn version ->
      Eventful.Transit.perform(version, bot, "deactivate", comment: "testing period expired")
    end)

    :ok
  end
end

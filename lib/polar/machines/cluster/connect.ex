defmodule Polar.Machines.Cluster.Connect do
  use Oban.Worker, queue: :default

  alias Polar.Repo
  alias Polar.Accounts.User
  alias Polar.Machines.Cluster

  @lexdee Application.compile_env(:polar, :lexdee) || Lexdee

  def perform(%Job{args: %{"user_id" => user_id, "cluster_id" => cluster_id}}) do
    user = Repo.get(User, user_id)
    %{credential: credential} = cluster = Repo.get(Cluster, cluster_id)

    client =
      Lexdee.create_client(
        credential["endpoint"],
        credential["certificiate"],
        credential["private_key"]
      )

    params = %{
      "password" => credential["password"],
      "certificate" => credential["certificate"]
    }

    case @lexdee.create_certificate(client, params) do
      {:ok, _response} ->
        Eventful.Transit.perform(cluster, user, "healthy")

      {:error, %{"error" => "Certificate already in trust store"}} ->
        Eventful.Transit.perform(cluster, user, "healthy")

      {:error, %{"error" => reason, "error_code" => 403}} ->
        Eventful.Transit.perform(cluster, user, "revert", comment: reason)

      _ ->
        Eventful.Transit.perform(cluster, user, "revert",
          comment: "Create certificate failed, make sure port is open."
        )
    end
  end
end

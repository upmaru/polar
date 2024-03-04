defmodule PolarWeb.Publish.StorageJSON do
  def show(%{storage: storage}) do
    %{
      data: %{
        access_key_id: storage.access_key_id,
        secret_access_key: storage.secret_access_key,
        bucket: storage.bucket,
        region: storage.region,
        endpoint: storage.endpoint
      }
    }
  end
end

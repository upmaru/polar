defmodule Polar.AWS do
  def get_signed_url(object_path, opts \\ [ttl: 86_400]) do
    %{
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      region: region,
      bucket: bucket,
      endpoint: endpoint
    } = config()

    scheme = Keyword.get(opts, :scheme, "https://")

    datetime = :erlang.universaltime()
    method = "GET"

    url = Enum.join([scheme, "#{endpoint}:9000", "/", bucket, "/", object_path])

    signed_url =
      :aws_signature.sign_v4_query_params(
        access_key_id,
        secret_access_key,
        region,
        "s3",
        datetime,
        method,
        url,
        opts
      )

    signed_url
  end

  def config do
    Application.get_env(:polar, __MODULE__)
    |> Enum.into(%{})
  end

  def client(access_key_id, secret_access_key, region, options \\ []) do
    finch_name = Keyword.get(options, :finch, Polar.Finch)

    access_key_id
    |> AWS.Client.create(secret_access_key, region)
    |> AWS.Client.put_http_client({AWS.HTTPClient.Finch, [finch_name: finch_name]})
  end
end

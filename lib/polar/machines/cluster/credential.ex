defmodule Polar.Machines.Cluster.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(endpoint password password_confirmation)a
  @required_attrs ~w(endpoint password private_key certificate)a

  @primary_key false
  embedded_schema do
    field :endpoint, :string

    field :password, :string
    field :password_confirmation, :string, virtual: true

    field :private_key, :string
    field :certificate, :string
  end

  @spec create!(map) :: %__MODULE__{}
  def create!(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_action!(:insert)
  end

  def update!(credential, attrs) do
    credential
    |> cast(attrs, [:endpoint])
    |> apply_action!(:insert)
  end

  def changeset(credential, attrs) do
    credential
    |> cast(attrs, @valid_attrs)
    |> generate_certificate()
    |> validate_password()
    |> validate_required(@required_attrs)
  end

  defp validate_password(changeset) do
    validate_change(changeset, :password, fn :password, password ->
      password_confirmation = get_change(changeset, :password_confirmation)

      if password == password_confirmation do
        []
      else
        [password: "do not match"]
      end
    end)
  end

  defp generate_certificate(changeset) do
    ca_key = X509.PrivateKey.new_ec(:secp256r1)

    ca =
      X509.Certificate.self_signed(
        ca_key,
        "/C=US/ST=DE/L=Newark/O=Upmaru/CN=instellar.app",
        template: :root_ca
      )

    ca_key = X509.PrivateKey.to_pem(ca_key)

    ca = X509.Certificate.to_pem(ca)

    changeset
    |> put_change(:private_key, ca_key)
    |> put_change(:certificate, ca)
  end
end

defmodule Polar.StreamsFixtures do
  def valid_product_attributes("alpine:3.19:amd64:default") do
    %{
      aliases: ["alpine/3.19", "alpine/3.19/default"],
      arch: "amd64",
      os: "Alpine",
      release: "3.19",
      release_title: "3.19",
      variant: "default",
      requirements: %{
        secureboot: false
      }
    }
  end
end

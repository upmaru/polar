# Polar

Polar is an image server for LXD / Incus. It has some useful features like:

+ Per `space` credential generation.
+ Feed specific to incus / lxd, you can choose when creating credentials.
+ Users can create `spaces` to manage multiple credentials.

The build system for polar is called [icepak](https://github.com/upmaru/icepak). It's designed to run as a github action, you can see it in action [here](https://github.com/upmaru/opsmaru-images).

## Demo

+ [Sandbox Site](https://images.opsmaru.dev)

## Basic Architecture

![basic design](/design.png)

## Development

Make sure you have Elixir / OTP installed. If you have asdf in your environment simply run 

```shell
asdf install
```

### Install Dependencies

Install dependencies using mix:

```shell
mix deps.get
```

### Start Server

You can start the server with the following command. It will be hosted on port 4000

```shell
iex -S mix phx.server
```
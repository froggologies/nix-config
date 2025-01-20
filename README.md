# NIX Config

This repository contains the Nix configuration for macOS using `nix-darwin`. Follow the steps below to get started.

## Prerequisites

You need to have [homebrew](https://brew.sh/) installed on your system.

## Getting started

### Step 1. Install Nix

First, install Nix on your system:

```sh
sh <(curl -L https://nixos.org/nix/install)
```

For more details, refer to the official [Nix installation guide](https://nixos.org/download/).

### Step 2: Clone this Repository

Clone this repository into your .config directory:

```sh
cd ~/.config && git clone https://github.com/froggologies/nix-config.git nix
```

Update the configuration name to match your system’s hostname:

```sh
sed -i '' "s/Frog/$(scutil --get LocalHostName)/" ~/.config/nix/flake.nix
```

### Step 3. Install nix-darwin

Run the following command to install nix-darwin using the flake:

```sh
nix run nix-darwin -- switch --flake ~/.config/nix
```

### Step 4. Apply Changes with darwin-rebuild

To apply the configuration, use:

```sh
darwin-rebuild switch --flake ~/.config/nix
```

## Update flakes

Keep your flakes up to date by running:

```sh
nix flake update --flake ~/.config/nix/
```

After updating, rebuild the configuration:

```sh
darwin-rebuild switch --flake ~/.config/nix-darwin
```

---

Feel free to customize this configuration as needed. 🚀

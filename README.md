# NIX Config

## Getting started

### Step 1. Install [nix](https://nixos.org/)

```sh
sh <(curl -L https://nixos.org/nix/install)
```

### Step 2. Clone the repository to .config

```sh
cd ~/.config && git clone https://github.com/froggologies/nix-config.git nix
```

Change the configuration name to hostname if needed.

```sh
# Get the current hostname
scutil --get LocalHostName
```

or

```sh
sed -i '' "s/Frog/$(scutil --get LocalHostName)/" ~/.config/nix/flake.nix
```

### Step 3. Installing nix-darwin

```sh
nix run nix-darwin -- switch --flake ~/.config/nix
```

### Step 4. Using nix-darwin

```sh
darwin-rebuild switch --flake ~/.config/nix
```

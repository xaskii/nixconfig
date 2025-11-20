#!/usr/bin/env fish
# Rebuild script for NixOS/Darwin configuration
# Works even on fresh systems without experimental features enabled

function show_help
    echo "Usage: rebuild.fish [OPTIONS] [HOST]"
    echo ""
    echo "Rebuild a NixOS or Darwin configuration"
    echo ""
    echo "Options:"
    echo "  --remote          Build remotely on the target host"
    echo "  --help, -h        Show this help message"
    echo ""
    echo "Arguments:"
    echo "  HOST              The hostname to build (defaults to current hostname)"
    echo ""
    echo "Examples:"
    echo "  ./rebuild.fish              # Build for current host"
    echo "  ./rebuild.fish four         # Build for host 'four'"
    echo "  ./rebuild.fish --remote unagi  # Build remotely on 'unagi'"
end

# Parse arguments
set -l remote false
set -l host ""
set -l extra_args

for arg in $argv
    switch $arg
        case --help -h
            show_help
            exit 0
        case --remote
            set remote true
        case '--*'
            set -a extra_args $arg
        case '*'
            if test -z "$host"
                set host $arg
            else
                set -a extra_args $arg
            end
    end
end

# Determine hostname
if test -z "$host"
    if test "$remote" = "true"
        echo (set_color red --bold)"error:"(set_color normal) "hostname not specified for remote build"
        exit 1
    end
    set host (hostname -s)
end

# Warn if building for different hostname
if test "$host" != (hostname -s); and test "$remote" != "true"
    echo (set_color yellow --bold)"warn:"(set_color normal) "building local configuration for hostname that does not match the local machine"
end

# Handle remote build
if test "$remote" = "true"
    echo (set_color blue --bold)"info:"(set_color normal) "building remotely on $host"

    # Clean up old config
    ssh -tt "root@$host" "rm -rf ncc"

    # Sync files
    git ls-files | rsync \
        --archive \
        --compress \
        --delete --recursive --force \
        --delete-excluded \
        --human-readable \
        --delay-updates \
        --files-from=- \
        ./ "root@$host:ncc"

    # Run rebuild on remote
    ssh -tt "root@$host" "cd ncc && ./rebuild.fish $host $extra_args"
    exit $status
end

# Determine OS type
set -l os_type (uname -s)

# Set up nix flags for systems without experimental features
set -l nix_flags \
    --extra-experimental-features "nix-command flakes pipe-operators" \
    --accept-flake-config

# Check if nh is available
if command -q nh
    echo (set_color blue --bold)"info:"(set_color normal) "using nh for rebuild"

    if test "$os_type" = "Darwin"
        nh darwin switch . --hostname "$host" $extra_args -- $nix_flags
    else
        env NH_BYPASS_ROOT_CHECK=true nh os switch . --hostname "$host" $extra_args -- $nix_flags
    end
else
    echo (set_color yellow --bold)"warn:"(set_color normal) "nh not found, using native rebuild commands"

    if test "$os_type" = "Darwin"
        darwin-rebuild switch --flake ".#$host" $nix_flags $extra_args
    else
        # NixOS rebuild
        if test (id -u) -eq 0
            nixos-rebuild switch --flake ".#$host" $nix_flags $extra_args
        else
            sudo nixos-rebuild switch --flake ".#$host" $nix_flags $extra_args
        end
    end
end

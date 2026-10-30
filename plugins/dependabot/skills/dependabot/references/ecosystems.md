# Supported Ecosystems Reference

This file contains the complete mapping of user aliases to Dependabot CLI ecosystem values, and the detection methods for auto-discovery.

Source: `packageManagerLookup` in the Dependabot CLI (`internal/infra/run.go`) and each ecosystem's `file_fetcher.rb` in dependabot-core.

## Ecosystem Alias Mapping

Map common user phrases to Dependabot CLI ecosystem values:

| User Says | CLI Ecosystem |
|-----------|---------------|
| npm, yarn, pnpm | `npm_and_yarn` |
| bun | `bun` |
| deno | `deno` |
| github-actions, actions, workflows | `github_actions` |
| pre-commit, prek | `pre_commit` |
| terraform, tf | `terraform` |
| opentofu, tofu | `opentofu` |
| go, golang | `go_modules` |
| python, pip, pipenv, poetry | `pip` |
| uv | `uv` |
| conda | `conda` |
| ruby, bundler, gems | `bundler` |
| rust, cargo | `cargo` |
| rust-toolchain, rustup | `rust_toolchain` |
| docker, dockerfile | `docker` |
| docker-compose, compose | `docker_compose` |
| devcontainers, devcontainer | `devcontainers` |
| maven, java | `maven` |
| gradle | `gradle` |
| sbt, scala | `sbt` |
| bazel | `bazel` |
| composer, php | `composer` |
| nuget, dotnet, csharp | `nuget` |
| dotnet-sdk, global.json | `dotnet_sdk` |
| helm | `helm` |
| dart, flutter, pub | `pub` |
| swift | `swift` |
| elixir, hex | `hex` |
| elm | `elm` |
| julia | `julia` |
| nix, flakes | `nix` |
| vcpkg | `vcpkg` |
| submodules, git-submodules | `submodules` |

## Ecosystem Auto-Detection

Detect which ecosystems are present using file existence checks:

| Ecosystem | CLI Value | Detection Method |
|-----------|-----------|------------------|
| GitHub Actions | `github_actions` | Glob: `.github/workflows/*.yml` or `.github/workflows/*.yaml` |
| pre-commit | `pre_commit` | File exists: `.pre-commit-config.yaml`, `.pre-commit-config.yml`, `.pre-commit.yaml`, or `.pre-commit.yml` |
| Terraform | `terraform` | Glob: `*.tf` or `**/*.tf` (check root and subdirs) |
| OpenTofu | `opentofu` | Glob: `**/*.tofu` |
| npm/yarn/pnpm | `npm_and_yarn` | File exists: `package.json` (and no `bun.lock`) |
| Bun | `bun` | File exists: `package.json` and `bun.lock` |
| Deno | `deno` | File exists: `deno.json` or `deno.jsonc` |
| Go | `go_modules` | File exists: `go.mod` |
| Python (pip) | `pip` | File exists: `requirements.txt`, `pyproject.toml`, `Pipfile`, or `setup.py` (and no `uv.lock`) |
| Python (uv) | `uv` | File exists: `uv.lock` |
| Conda | `conda` | File exists: `environment.yml` or `environment.yaml` |
| Ruby | `bundler` | File exists: `Gemfile` |
| Rust | `cargo` | File exists: `Cargo.toml` |
| Rust toolchain | `rust_toolchain` | File exists: `rust-toolchain.toml` or `rust-toolchain` |
| Docker | `docker` | Glob: `Dockerfile` or `*.dockerfile` |
| Docker Compose | `docker_compose` | Glob: `docker-compose*.yml`, `docker-compose*.yaml`, `compose*.yml`, or `compose*.yaml` |
| Dev Containers | `devcontainers` | Glob: `**/devcontainer.json` or `.devcontainer.json` |
| Maven | `maven` | File exists: `pom.xml` |
| Gradle | `gradle` | File exists: `build.gradle` or `build.gradle.kts` |
| sbt | `sbt` | File exists: `build.sbt` |
| Bazel | `bazel` | File exists: `MODULE.bazel`, `WORKSPACE`, or `WORKSPACE.bazel` |
| Composer | `composer` | File exists: `composer.json` |
| NuGet | `nuget` | Glob: `*.csproj` or `packages.config` or `*.fsproj` |
| .NET SDK | `dotnet_sdk` | File exists: `global.json` |
| Helm | `helm` | File exists: `Chart.yaml` |
| Pub (Dart) | `pub` | File exists: `pubspec.yaml` |
| Swift | `swift` | File exists: `Package.swift` |
| Hex (Elixir) | `hex` | File exists: `mix.exs` |
| Elm | `elm` | File exists: `elm.json` |
| Julia | `julia` | File exists: `Project.toml` or `JuliaProject.toml` |
| Nix | `nix` | File exists: `flake.nix` and `flake.lock` |
| vcpkg | `vcpkg` | File exists: `vcpkg.json` or `vcpkg-configuration.json` |
| Git submodules | `submodules` | File exists: `.gitmodules` (scan without `--local`, see SKILL.md step 4) |

## Shared Manifests

Some ecosystems read the same files. The CLI scans whichever ecosystem it is given, so pick one:

- `package.json`: `bun` when `bun.lock` exists, otherwise `npm_and_yarn`.
- `pyproject.toml` / `requirements.txt`: `uv` when `uv.lock` exists, otherwise `pip`.
- `*.tf`: `terraform`. Add `opentofu` only when `*.tofu` files exist.

`apm` (`apm.yml`) is also in the CLI, but dependabot-core gates it behind `enable-beta-ecosystems`. Do not auto-detect it.

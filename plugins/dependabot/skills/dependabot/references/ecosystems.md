# Supported Ecosystems Reference

This file contains the complete mapping of user aliases to Dependabot CLI ecosystem values, and the detection methods for auto-discovery.

## Ecosystem Alias Mapping

Map common user phrases to Dependabot CLI ecosystem values:

| User Says | CLI Ecosystem |
|-----------|---------------|
| npm, yarn, pnpm | `npm_and_yarn` |
| github-actions, actions, workflows | `github_actions` |
| terraform, tf | `terraform` |
| go, golang | `go_modules` |
| python, pip, pipenv | `pip` |
| ruby, bundler, gems | `bundler` |
| rust, cargo | `cargo` |
| docker | `docker` |
| maven, java | `maven` |
| gradle | `gradle` |
| composer, php | `composer` |
| nuget, dotnet, csharp | `nuget` |
| helm | `helm` |
| dart, flutter, pub | `pub` |
| swift | `swift` |
| elixir, hex | `hex` |

## Ecosystem Auto-Detection

Detect which ecosystems are present using file existence checks:

| Ecosystem | CLI Value | Detection Method |
|-----------|-----------|------------------|
| GitHub Actions | `github_actions` | Glob: `.github/workflows/*.yml` or `.github/workflows/*.yaml` |
| Terraform | `terraform` | Glob: `*.tf` or `**/*.tf` (check root and subdirs) |
| npm/yarn/pnpm | `npm_and_yarn` | File exists: `package.json` |
| Go | `go_modules` | File exists: `go.mod` |
| Python (pip) | `pip` | File exists: `requirements.txt`, `pyproject.toml`, `Pipfile`, or `setup.py` |
| Ruby | `bundler` | File exists: `Gemfile` |
| Rust | `cargo` | File exists: `Cargo.toml` |
| Docker | `docker` | Glob: `Dockerfile` or `*.dockerfile` or `docker-compose.yml` |
| Maven | `maven` | File exists: `pom.xml` |
| Gradle | `gradle` | File exists: `build.gradle` or `build.gradle.kts` |
| Composer | `composer` | File exists: `composer.json` |
| NuGet | `nuget` | Glob: `*.csproj` or `packages.config` or `*.fsproj` |
| Helm | `helm` | File exists: `Chart.yaml` |
| Pub (Dart) | `pub` | File exists: `pubspec.yaml` |
| Swift | `swift` | File exists: `Package.swift` |
| Hex (Elixir) | `hex` | File exists: `mix.exs` |

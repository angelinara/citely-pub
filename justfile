# List recipes
default:
    @just --list

# Install tools and dependencies
[group('setup')]
install: githooks
    @brew install betterleaks # the pre-push hook's secret scan

# Install Git hooks
[group('setup')]
githooks:
    @git config core.hooksPath hooks

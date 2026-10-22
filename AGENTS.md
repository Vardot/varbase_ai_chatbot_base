# AGENTS.md

Guidance for AI coding agents working on the Varbase AI Chatbot Base recipe.

This is a **private** recipe on GitHub (`Vardot/varbase_ai_chatbot_base`), not a drupal.org project. Issues,
pull requests and CI all live on GitHub.

## Before you start

- **`CHANGELOG.md`**: what changed in each release, newest first. Read it before proposing a change.
- **Pull requests and their discussions** on
  [github.com/Vardot/varbase_ai_chatbot_base](https://github.com/Vardot/varbase_ai_chatbot_base/pulls): the
  reasoning behind recent changes.
- **Issues** on [github.com/Vardot/varbase_ai_chatbot_base/issues](https://github.com/Vardot/varbase_ai_chatbot_base/issues):
  the Problem/Motivation and Proposed resolution for each change.
- **`README.md`**: what was checked, what was not, and the known issues, including why the chatbot block cannot be
  placed on a Canvas theme yet.
- **[Varbase AI Search](https://github.com/Vardot/varbase_ai_search_base)**: its `content_vector` index is what the
  agent searches. This recipe never builds or fills an index of its own.

## When you make a change

- One issue and one pull request per change. The PR says `Closes #<issue>` and ends with the Checkpoints list
  from `.github/pull_request_template.md`.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
- CI must be green before merging: `.github/workflows/ci.yml` lints the repository, then applies Varbase AI Search
  and this recipe twice on a real Drupal 11.4 site with MariaDB 11.8, and runs the no-key recipe check.
- CI reads Varbase AI Search with a read-only deploy key: the secret `VARBASE_AI_SEARCH_DEPLOY_KEY` here, and the
  deploy key on `Vardot/varbase_ai_search_base`. Never replace it with a personal token or a key that can write.
- No PHP in the repository at all: no `.php`, `.module`, `.install` or `.inc` file. The no-key checks run inline in
  `.github/workflows/ci.yml` (`drush php:eval`), and the lint job fails on any PHP file.
- Do not place the chatbot block in a Canvas region from the recipe. Canvas has no config action that adds one
  component without replacing the region's whole tree.
- Never bump the version or tag a release without explicit maintainer approval. Tags are three-segment
  (`1.0.0`) and are never moved once pushed.

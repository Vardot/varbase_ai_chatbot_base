# Changelog

All notable changes to the Varbase AI Chatbot Base recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2026-10-12
### Changed
- Removed `tests/verify.php`: the repository now holds no PHP file. CI runs the same no-key checks inline
  (`drush php:eval` in `.github/workflows/ci.yml`), and the lint job fails on any `.php`, `.module`, `.install` or
  `.inc` file (#7).

### Checked
- CI on 1.0.x (https://github.com/Vardot/varbase_ai_chatbot_base/actions/runs/38238498400): the lint job found no PHP file, the recipe applied twice, the inline
  check printed `RESULT: PASS` and the functional tests passed.

## [1.0.1] - 2026-10-11
### Added
- Functional tests in `tests/features`, run in CI after `tests/verify.php`: Playwright and Cucumber
  through `@vardot/varbase-e2e`, in Chromium, against the Varbase 11 site CI builds. They check the admin pages
  the recipe sets up.
### Changed
- Require `vardot/varbase_ai_search_base`, the renamed Varbase AI Search, and point the CI and the
  README at it.

## [1.0.0] - 2026-10-08
### Added
- The recipe: a grounded `varbase_ai_chatbot` retrieval agent locked to the `content_vector` index of Varbase AI
  Search, a "Varbase AI chatbot" AI Assistant for the DeepChat chatbot block, and `access deepchat api` for
  anonymous and authenticated users.
- `tests/verify.php`: checks the modules, the index, the agent, the assistant and the permission with no AI key,
  and asks questions through the assistant when given them.
- GitHub Actions CI: lint, then a real Varbase 11 site (`drupal/varbase_project` `11.0.x-dev` with Varbase's curated
  patches, installed from Varbase Starter) on MariaDB 11.8, which is also the vector database, with the AI
  module's Echo test provider as the default embeddings model. It applies Varbase Search Base, the provider and
  the defaults, then Varbase AI Search, then this recipe twice, and runs `tests/verify.php`. Varbase AI Search is
  read with a read-only deploy key (`VARBASE_AI_SEARCH_DEPLOY_KEY`).
- README in the Varbase AI recipe style, `AGENTS.md`, `LICENSE`, `logo.png`, composer metadata, and the Vardot
  issue and pull request templates.

### Changed
- Renamed to Varbase AI Chatbot Base, beside the other Varbase AI recipes.
- Require `vardot/varbase_ai_search: ^1.0`.

### Fixed
- `tests/verify.php` now fails the command when a check fails. It only printed FAIL before.
- The index-content line of `tests/verify.php` is now INFO, not a check. Indexing is Varbase AI Search's job, and
  in CI the index is empty by design.

[Unreleased]: https://github.com/Vardot/varbase_ai_chatbot_base/compare/1.0.2...1.0.x
[1.0.2]: https://github.com/Vardot/varbase_ai_chatbot_base/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/Vardot/varbase_ai_chatbot_base/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/Vardot/varbase_ai_chatbot_base/releases/tag/1.0.0

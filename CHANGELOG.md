## [develop-v1.1.1] - 2026-02-27

### 🐛 Bug Fixes

- Update add-to-project action to v1.0.2 (#42)
- Update consuming repos to language-specific library names (#45)

### 🚜 Refactor

- *(ci)* Remove docs-only detection and add tier-1 validation scripts (#50)

### 📚 Documentation

- Add MkDocs site, docs deployment workflow, and update repository profile (#44)
- Replace stale script references with st-* commands (#48)
- Complete documentation site with onboarding, port allocation, and env var references (#55)
- Add Releases nav section to documentation site (#57)

### ⚙️ Miscellaneous Tasks

- Bump version to 1.1.1
- Sync standard-tooling v1.1.4 (#40)
- Migrate to PATH-based standard-tooling consumption (#47)
- *(ci)* Add MQ listener port inputs to setup-mq composite action (#53)
## [1.1.0] - 2026-02-21

### 🐛 Bug Fixes

- Fix CHANGELOG.md formatting for markdownlint compliance
- Escape glob patterns in CHANGELOG.md for markdownlint

### ⚙️ Miscellaneous Tasks

- Merge main into release/1.1.0
- Prepare release 1.1.0
## [develop-v1.1.0] - 2026-02-21

### 🚀 Features

- Add repository scaffolding and design decisions (#1)
- Migrate Docker config and lifecycle scripts from pymqrest (#4)
- Rename PYMQREST.* object prefix to DEV.* (#7)
- Add setup-mq composite action for CI consumption (#9)
- Parameterize docker-compose for per-project isolation (#12)
- Add weekly Trivy container image scan
- *(ci)* Add category prefixes to job names (#27)
- *(validate)* Adopt validate_local.sh dispatch architecture (#30)
- *(ci)* Add publish workflow for automated tagging and version bumps (#36)

### 📚 Documentation

- Add full README and mark pymqrest migration complete
- Update self-references after repository rename (#18)
- Ban MEMORY.md usage in CLAUDE.md (#28)
- Ban heredocs in shell commands (#29)

### ⚙️ Miscellaneous Tasks

- Auto-add issues to GitHub Project (#16)
- Bootstrap sync-tooling and add commit/PR wrapper scripts (#20)
- Add CI workflow with docs-only detection and shellcheck (#22)
- Sync shared tooling to v1.0.5 (#24)
- Add .gitignore with __pycache__ exclusion (#26)
- Sync managed scripts against standard-tooling v1.1.1 (#31)
- *(ci)* Remove push trigger from CI workflow (#33)

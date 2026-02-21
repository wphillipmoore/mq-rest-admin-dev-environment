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
- Merge main into release/1.1.0

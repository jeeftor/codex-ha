# HA Assistant Config

`$ha-init` writes local config to:

```text
~/.codex/ha-assistant/config.yaml
```

Example:

```yaml
repos_root: ~/devel/ha
repos:
  core: ~/devel/ha/core
  docs: ~/devel/ha/home-assistant.io
maintainer:
  github: jeeftor
integrations:
  weatherflow_cloud:
    core_path: ~/devel/ha/core/homeassistant/components/weatherflow_cloud
    tests_path: ~/devel/ha/core/tests/components/weatherflow_cloud
    docs_path: ~/devel/ha/home-assistant.io/source/_integrations/weatherflow_cloud.markdown
    backing_libraries:
      - name: weatherflow4py
        path: ~/devel/ha/weatherflow4py
        requirement: weatherflow4py
```

Rules:

- Treat config values as hints.
- Verify paths exist before using them.
- If multiple library candidates match a requirement, ask before editing.
- Keep personal config outside the plugin so the plugin remains distributable.

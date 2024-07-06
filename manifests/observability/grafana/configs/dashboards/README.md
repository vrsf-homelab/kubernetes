# Grafana Dashboards

## How to add

### Creating a new folder

1. Create a new directory and place a JSON file(s) with dashboard content (from Export options).
2. In `kustomization.yaml` create a new section in `configMapGenerator` with paths to JSON files.
3. In `values.yaml`:
   1. In `dashboardProviders.dashboardProviders.yaml` add a new section as a folder in Grafana.
   2. In `dashboardsConfigMaps` add a new entry, where key is a provider name and as a value CM name created in `kustomization.yaml.

### Using an existing folder

1. Save a JSON file(s) with dashboard content in a desired folder.
2. In `kustomization.yaml` update desired section by adding a new file(s) paths.

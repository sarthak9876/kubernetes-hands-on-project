# Images Directory

This folder contains all visual assets used in the Kubernetes hands-on project documentation, including architecture diagrams, workflow illustrations, and screenshots for teaching and demonstration purposes.

## Structure
```
images/
├── architecture/   # Cluster, application, and network diagrams
├── diagrams/       # Deployment, upgrade, and process flows
├── screenshots/
│   ├── application/  # UI and app screenshots
│   ├── dashboard/    # Monitoring dashboards (Grafana, Prometheus)
│   └── monitoring/   # Monitoring setup and alerts
```

## Usage
- Add PNG, JPG, or SVG files to the appropriate subfolder.
- Reference images in documentation using relative paths, e.g.:
  ```markdown
  ![Cluster Architecture](images/architecture/cluster-overview.png)
  ```
- Use screenshots to illustrate key steps, results, and troubleshooting.
- Use diagrams to explain concepts, workflows, and system design.

## Best Practices
- Use clear, high-resolution images.
- Name files descriptively (e.g., `cluster-overview.png`, `grafana-dashboard.png`).
- Keep diagrams up to date with project changes.
- Avoid including sensitive information in screenshots.

## Contribution
If you add new images, update this README and reference them in relevant documentation files for better learning and navigation.

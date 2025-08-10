# Troubleshooting Common Issues

This guide covers common problems encountered during Kubernetes cluster setup and how to resolve them. Each issue includes the symptoms, root cause, and step-by-step solutions.

---

## 1. Node Not Ready

**Symptoms:**
- `kubectl get nodes` shows one or more nodes as `NotReady`.

**Possible Causes & Solutions:**
- **Swap is enabled:**
  - Run `sudo swapoff -a` and comment out swap in `/etc/fstab`.
- **Kubelet not running:**
  - Check status: `sudo systemctl status kubelet`
  - View logs: `journalctl -xeu kubelet`
- **Network plugin not working:**
  - Check CNI pod status: `kubectl get pods -n kube-system`
  - Review CNI logs: `kubectl logs <cni-pod> -n kube-system`

---

## 2. Pods Stuck in Pending

**Symptoms:**
- `kubectl get pods` shows pods stuck in `Pending` state.

**Possible Causes & Solutions:**
- **No available nodes:**
  - Check node status: `kubectl get nodes`
- **Insufficient resources:**
  - Describe pod: `kubectl describe pod <pod-name>`
  - Look for resource requests/limits issues
- **Network not configured:**
  - Ensure CNI is installed and pods are running

---

## 3. Metrics Not Available

**Symptoms:**
- `kubectl top nodes` or `kubectl top pods` returns `metrics not available`.

**Possible Causes & Solutions:**
- **Metrics Server not running:**
  - Check pod status: `kubectl get pods -n kube-system | grep metrics-server`
  - View logs: `kubectl logs <metrics-server-pod> -n kube-system`
- **TLS issues:**
  - Edit deployment to add `--kubelet-insecure-tls` (see Metrics Server guide)
- **Firewall/network issues:**
  - Ensure port 10250 is open between nodes

---

## 4. Cluster Networking Issues

**Symptoms:**
- Pods on different nodes cannot communicate

**Possible Causes & Solutions:**
- **CNI not installed or misconfigured:**
  - Check Flannel/other CNI pod status and logs
- **Firewall rules blocking traffic:**
  - Review AWS security group settings

---

## General Debugging Tips
- Use `kubectl describe` to get detailed info on resources
- Use `kubectl logs` to view pod logs
- Check node status and events: `kubectl get nodes`, `kubectl get events --sort-by=.metadata.creationTimestamp`
- Use `journalctl` for systemd service logs (e.g., kubelet)

---

**Next:** Continue with [application deployment](../02-application-deployment/README.md) or see other guides for advanced troubleshooting.

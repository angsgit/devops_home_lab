# 🧮 Troubleshooting & Incident Log

This document records key issues encountered during the DevOps CI/CD project — including root cause analysis, diagnostic steps, and resolutions.  

---

## ⚠️ 1️⃣ BackOff Restarting Failed Container (`CrashLoopBackOff`)

**Symptom:**
```
Warning  BackOff  ...  Back-off restarting failed container webapp
```

**Diagnosis:**
- Ran `kubectl describe pod` → container repeatedly restarting.
- Checked logs via:
  ```bash
  kubectl logs <pod-name> -n app-v1
  ```
  Output:
  ```
  ModuleNotFoundError: No module named 'prometheus_client'
  ```
- Flask app crashed at startup due to a missing Python dependency.

**Root Cause:**  
Missing `prometheus_client` library in the Docker image.

**Resolution:**
1. Added `prometheus_client` to `requirements.txt`.
2. Jenkins rebuilt the image and redeployed automatically.
3. Verified fix with:
   ```bash
   kubectl logs <pod> -n app-v1
   kubectl run curltest -n app-v1 --rm -it --image=curlimages/curl -- curl -s http://webapp:8000/metrics
   ```

✅ **Result:** Pod started successfully; Prometheus `/metrics` endpoint responded with `200 OK`.

---

## 🧱 2️⃣ Pod Pending — Disk Pressure / Scheduling Issue

**Symptom:**
Pods stuck in `Pending`:
```
0/3 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane:}, 2 node(s) had untolerated taint {node.kubernetes.io/disk-pressure:}.
```

**Diagnosis:**
- Checked node conditions:
  ```bash
  kubectl describe node <node> | grep -i pressure
  ```
  → Found disk pressure on workers.
- Control-plane node tainted (pods not scheduled there).

**Root Cause:**  
Low disk space and taints prevented pod scheduling.

**Resolution:**
- Increased VM disk size to 20 GB (VMware Workstation).
- Removed control-plane taint temporarily:
  ```bash
  kubectl taint nodes --all node-role.kubernetes.io/control-plane-
  ```

✅ **Result:** Prometheus, Grafana, and other pods successfully scheduled and running.

---

## ⚙️ 3️⃣ Grafana Inaccessible from Host

**Symptom:**  
Grafana dashboard not reachable at `localhost:3000`.

**Diagnosis:**
```bash
kubectl get svc -n monitoring kube-prometheus-grafana
```
→ Service type was `ClusterIP` (internal only).

**Root Cause:**  
Grafana not exposed externally.

**Resolution:**
- Changed service type to `NodePort`:
  ```bash
  kubectl patch svc kube-prometheus-grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'
  ```
- Accessed Grafana via `<worker-node-ip>:<nodeport>`.

✅ **Result:** Grafana accessible from the host machine browser.

---

## 🧠 4️⃣ Prometheus Not Scraping Flask Metrics

**Symptom:**  
`http_requests_total` not visible in Prometheus or Grafana.

**Diagnosis:**
- Validated app metrics endpoint:
  ```bash
  kubectl run curltest -n app-v1 --rm -it --image=curlimages/curl -- curl -s http://webapp:8000/metrics
  ```
- Endpoint returned valid metrics.
- Checked Prometheus targets; Flask app missing.

**Root Cause:**  
No `ServiceMonitor` existed for the app.

**Resolution:**
Created `ServiceMonitor`:
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: flaskapp-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: webapp
  endpoints:
    - port: http
      interval: 15s
  namespaceSelector:
    matchNames:
      - app-v1
```

✅ **Result:**  
Prometheus began scraping Flask metrics.  
Grafana visualization confirmed via:
```
sum by (endpoint) (rate(http_requests_total[1m]))
```

---

## 🧩 5️⃣ Old Pods Remaining After Redeploy

**Symptom:**  
Old pods remained in `Error` or `Terminating` state.

**Diagnosis:**
```bash
kubectl get pods -n app-v1
```
→ Multiple ReplicaSets active.

**Root Cause:**  
Failed pods not automatically cleaned up after redeployments.

**Resolution:**
Manually cleaned up:
```bash
kubectl delete pods --field-selector=status.phase=Failed -n app-v1
kubectl delete rs --all -n app-v1
```

✅ **Result:** Deployment stabilized; only healthy pods remained.

---

## 🧩 6️⃣ Jenkinsfile Case Sensitivity Issue (Git)

**Symptom:**  
Jenkins pipeline failed to detect `Jenkinsfile` after renaming locally.

**Diagnosis:**  
Windows filesystem is case-insensitive, so Git didn’t register the rename.

**Resolution:**
```bash
git mv Jenkinsfile temp
git mv temp Jenkinsfile
git commit -m "Fix Jenkinsfile case issue"
git push
```

✅ **Result:** Jenkins recognized the correct file name and resumed pipeline builds.

---

# 💡 Lessons Learned & Preventive Actions

| Category | Lesson | Preventive Measure |
|-----------|--------|--------------------|
| **Dependencies** | Missing libraries caused crashes | Implement automated dependency scanning (e.g., `pip check`, SonarQube) |
| **Storage Management** | Low disk space disrupted scheduling | Monitor node storage via Prometheus alerts |
| **K8s Scheduling** | Control-plane taints blocked deployments | Define taints/tolerations clearly in manifests |
| **Service Exposure** | Internal-only services blocked access | Standardize on NodePort/Ingress for external tools |
| **Observability** | Missing ServiceMonitor = no metrics | Enforce monitoring CRD templates for new apps |
| **Git Hygiene** | Case sensitivity issues on Windows | Use consistent casing + commit automation checks |
| **Pod Lifecycle** | Old replicas not cleaned up | Use automated cleanup in CI/CD or retention policies |

---

✅ **Summary:**  
All issues were diagnosed, documented, and resolved systematically using Kubernetes commands, CI/CD pipeline logs, and monitoring tools.  
This process mirrors real-world DevOps troubleshooting and continuous improvement methodology.


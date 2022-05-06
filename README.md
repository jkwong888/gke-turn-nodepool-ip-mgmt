# jkwng-turn-nodepool-ip-mgmt

[daemonset](./daemonset) that changes a GKE nodepool's public IP to a static one if it gets reprovisioned.

- we use k8s downward API to discover the node's public IP
- we use `gcloud` to discover a static IP defined in compute engine
- if these don't match, unassign the ephemeral worker node IP and assign the public IP
  - note that the init container always fails because the worker node IP unassignment causes the `gcloud` command to fail.  but k8s will restart the init container and it will succeed the second time because the path to the compute engine API goes through the private subnet

we used [config connector](./configconnector-operator/) to [bind](./cc_iampolicy-wi-turn.yaml) the daemonset service account to a GCP service account and give it roles as well as to create the [static IP address](./cc_address_us-central1-ipv4.yaml).  Note the [permissions](./cc_iampolicy-turn.yaml) on the turn ip mgr service account:
- `compute.viewer` on the project to get vm instance details
- custom role on the project to be able to add and delete nat IP on VMs in the project
- `compute.networkUser` on the subnet to be able to use external IPs 
Why we do the nginx step

Your project requires that you:

Deploy multiple apps (inventory, billing, api-gateway)

Deploy StatefulSets (databases)

Use Services, PVCs, and autoscaling

Debug issues when pods don’t start

Before doing all that, you must be 100% sure that:

Your cluster is healthy
Both nodes can run pods.

Scheduling works
Pods should appear on both master and agent.

Networking works
Services must load-balance between pods.

kubectl can apply manifests
If applying a small test YAML fails, the real apps will definitely fail.

nginx is the simplest possible Deployment — it gives you a clean, safe way to confirm the cluster is working before you start writing 10+ manifests for your real architecture.

What happens if you skip the nginx test?

You might start deploying:

Postgres StatefulSets

RabbitMQ

API gateway

Microservices

And then you discover:

Pods are not scheduling

Services are unreachable

Agent isn’t joining correctly

Storage isn’t mounting

Which becomes very hard to debug because many components interact.

The nginx test prevents that.

Summary

Is nginx part of the project’s final architecture?
No.

Is it necessary to verify your cluster is ready for the real project?
Yes — it is the safest and fastest sanity check.

If you want, we can skip directly to:

Creating your project namespace

Writing the first real manifest (inventory-db StatefulSet)

Just confirm whether your cluster is working now or you want help deploying your first real component.
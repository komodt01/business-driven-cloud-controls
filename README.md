# Controls Demo: Business-Driven Guardrails for S3

> **Note on metrics and values**  
> All numbers, timings, and thresholds in this repo are **illustrative for this project/demo only**. They are not production SLAs or guarantees.

## Why this matters (business perspective)
- **Prevent avoidable loss:** Public S3 access is a common breach cause. Guardrails reduce probability and blast radius.
- **Prove compliance with evidence:** Preventive → detective → corrective controls actually working, with logs/screenshots.
- **Speed with safety:** Automation fixes risky drift faster than tickets/manual reviews.
- **Cost control:** Early detection + auto-remediation beats incident response and reputation damage.

## What this project is
A minimal, repeatable example that:
- **Prevents** risky configs by default (S3 Block Public Access).
- **Detects** public ACL changes (CloudTrail → EventBridge).
- **Corrects** them automatically (Lambda strips `AllUsers`/`AuthenticatedUsers` grants).
- **Governs** via docs, tags, lessons learned, and cleanup guidance.

## Use cases
- **Audit/Attestation:** Show working controls tied to SOC2/ISO/NIST objectives.
- **Guardrail bake-off:** Compare preventive vs. corrective tradeoffs with evidence.
- **Onboarding/Enablement:** Teach how cloud controls map to business goals.

## Success metrics (demo-only)
- Guardrail Coverage ≥ 95%  
- MTTD < 2 minutes; MTTR < 5 minutes  
- Auto-Remediation Rate ≥ 80%; False-Positive Rate ≤ 5%

> These are **fictional targets** for this demo.

## Repo layout

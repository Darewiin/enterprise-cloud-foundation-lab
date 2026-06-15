# Troubleshooting

Real issues encountered while building the Terraform foundation, and how each was resolved. Format: **Symptom → Root cause → Fix → Takeaway.**

---

## 1. `terraform plan` hangs, then fails with "context canceled"

**Symptom:** `terraform plan` appeared to freeze with no output for a long time. After interrupting it with Ctrl+C, the output showed `Planning failed` and a list of `waiting for Subscription Provider ... to be registered: context canceled` errors.

**Root cause:** By default, the `azurerm` provider attempts to register *every* Azure resource provider on the subscription before planning. This is slow, and on some accounts it requires permissions the signed-in user may not have. The plan was not actually frozen — it was working through that registration list when it was interrupted. The `context canceled` messages were a result of the Ctrl+C, not the underlying problem.

**Fix:** Disable bulk provider registration in `providers.tf`, since Azure auto-registers the few providers actually used:

```hcl
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
```

(On older azurerm v3, the equivalent is `skip_provider_registration = true`.)

**Takeaway:** A long pause in `terraform plan` is usually provider registration, not a hang. Let it finish before interrupting, and disable bulk registration for faster, permission-independent runs.

---

## 2. `.gitignore` had no effect

**Symptom:** After committing what was meant to be a `.gitignore`, nothing was being ignored, and a `git commit` showed `delete mode 100644 gitignore`.

**Root cause:** The file had been saved as `gitignore` (no leading dot) instead of `.gitignore`. A file without the leading dot is not recognized by Git as an ignore file and does nothing. On macOS, files beginning with a dot are also hidden in Finder by default, which made it hard to see what was actually there.

**Fix:** Create the file with the correct name directly, so the dot cannot be stripped — either via the terminal (`cat > .gitignore`) or by using GitHub's **Add file → Create new file** and typing `.gitignore`, then delete the misnamed `gitignore`.

**Takeaway:** Dotfiles are easy to mangle when downloaded or renamed through a GUI. Verify with `ls -la` (which shows hidden files) that the name is exactly `.gitignore`.

---

## 3. No logs appearing in Log Analytics

**Symptom:** After configuring Entra diagnostic settings to route logs to the workspace, a `SigninLogs | take 10` query returned no results, even after 15+ minutes.

**Root cause:** Two factors combined: (1) diagnostic settings are **not retroactive** — they only capture activity that occurs *after* they are saved, so earlier activity never appears; and (2) the first ingestion to a brand-new workspace can lag well beyond the usual few minutes while the pipeline warms up. On top of that, querying only `SigninLogs` misses non-interactive sign-ins, which are the highest-volume Entra log.

**Fix:** Generate a fresh interactive sign-in (an incognito login to the portal), set the query time range to **Last 24 hours**, and broaden the query across all Entra log tables:

```kusto
union AuditLogs, SigninLogs, AADNonInteractiveUserSignInLogs
| sort by TimeGenerated desc
| take 25
```

Within a short wait, rows appeared (predominantly `NonInteractiveUserSignInLogs`).

**Takeaway:** When verifying log ingestion, allow for first-ingestion latency, remember that diagnostic settings only capture future activity, and query a `union` of the relevant tables rather than a single one.

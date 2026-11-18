# DSU–CFCS
## Controlled Flexible Credit System · SET pilot release
**Dhanalakshmi Srinivasan University, Tamil Nadu | 2026–2027**

A working React + FastAPI + PostgreSQL academic management application, not a static dashboard. The running preview opens in the **Dean – SET** workspace. The campus engraving and shield are illustrative interface artwork rather than an authenticated university photograph or seal.

> **Synthetic environment.** The preview contains 1,248 synthetic students, six sample departments, four sample regulations, 48 sample faculty and 96 teaching sections. Names, curricula, equivalences, attendance decisions, capacities and policy values are testing fixtures, not official DSU information. Do not upload actual student records to the public demonstration. There are no bundled production credentials.

### Explore the live application
1. Open **DSU–CFCS Academic Workspace** in the live preview. Select a KPI or department row to drill into real database records.
2. Use the profile menu at the upper right to switch **synthetic demo roles**. No password is needed in the isolated demonstration; this endpoint refuses production access.
3. **Student → Course registration**: inspect available courses, all validation outcomes, the separate recovery basket, credit audit and timetable. Confirm a registration, set a ranked preference or request an exception.
4. **Dean / HoD → Course offerings / Approvals**: review teaching sections, independent regulation mappings, suggested instructors, evidence and delegated authority. Publish only after backend validation.
5. **Faculty → Timetable → teaching section → View class roster**: record course-wise attendance only for an assigned section.
6. **Super Administrator → Workspace settings**: manage master data, policies, accounts, delegated permissions, Excel templates, validated imports and the append-only audit trail.
7. **Reports & analytics**: select a report and export a real CSV, XLSX workbook or PDF. The same record-level permissions apply to download and screen views.

### Deliverables
| Item | Location |
|---|---|
| Architecture, logical ER model, screen inventory, API contract, phased development plan | `docs/01-system-architecture.md` |
| Executable PostgreSQL schema and incremental migrations | `migrations/001_foundation.sql` through `004_attempt_lifecycle.sql` |
| Physical database dictionary and relationship map | `docs/schema-dictionary.csv`, `docs/er-diagram.svg` |
| Machine-readable API specification and offline interactive reference | `docs/api-specification.json`, running route `/docs` |
| Administrator and role manuals | `docs/02-admin-and-user-guide.md` |
| Development, test, production, backup and recovery guide | `docs/03-deployment-and-recovery.md` |
| Test evidence and release gates | `docs/04-verification.md`, `docs/test-results.xml` |
| Printable pilot handbook | `DSU-CFCS-Pilot-Handbook.pdf` |

### Local development
Requirements: **PostgreSQL 15+ server and client**, Python 3.11+, Node 20+ (only for rebuilding the UI). The included Unix-socket preview launcher targets Linux and a non-root OS account. The workspace has been run on PostgreSQL 17 and Python 3.13.

```sh
python -m venv .venv
. .venv/bin/activate
pip install -r requirements-dev.txt
npm ci
npm run build
bash scripts/start-preview.sh
```

The server listens on `0.0.0.0:8000`. Local development address: `http://localhost:8000`. In Arena, use the proxied **live preview**, not localhost. All browser API calls are same-origin relative URLs. Fonts, JavaScript, CSS, illustration and API documentation assets are served locally.

The launcher initialises a **private Unix-socket-only** PostgreSQL cluster, applies migrations and explicitly seeds an empty synthetic database. It never reseeds a nonempty installation. `data/pilot.dump` is an atomic synthetic recovery snapshot, excluding sessions and login attempts; if the local cluster is absent the preview can restore this snapshot. Physical database files and installed dependencies are not required in the source bundle.

### Run verification
```sh
python -m playwright install --with-deps chromium
APP_MODE=synthetic python -m pytest tests -v --junitxml=docs/test-results.xml
```
Tests create and remove **random isolated schemas**, including a separate database-backed HTTP server for browser workflows. Configure `TEST_DATABASE_URL` for a dedicated PostgreSQL test instance. Never point a test runner at an institutional production database. Test credentials are generated at runtime.

### Backend boundaries
- `backend/core.py`: expiring, hashed bearer sessions; Argon2id credentials; explicit permissions and record scopes; transaction boundary.
- `backend/engine.py`: verified prerequisite groups, valid equivalences, semester window, recovery, credit policy, workload, rooms, seats, timetable, allocation and promotion.
- `backend/api.py`, `teaching.py`, `admin.py`: typed FastAPI workflows, catalogues, course-wise attendance, independent approval and master management.
- `backend/imports.py`: nine XLSX/CSV profiles, bounded parsing, Excel templates, row diagnostics, savepoint preview and confirmed all-or-nothing commit.
- `backend/queries.py`, `analytics.py`: scoped live transaction reports and dated cohort eligibility snapshots. **Snapshots never authorise a registration.**
- `backend/seed.py`: explicitly labelled synthetic fixtures, guarded by `APP_MODE=synthetic`.
- `frontend/src/`: responsive React application, accessible navigation/dialogs, data tables, chart interactions and real forms.

### Production handoff
This is a **tested pilot candidate**, not institutional authorisation to process live records. A managed database or public production deployment has not been provisioned. Supply a private managed PostgreSQL service, verified TLS, a secrets manager and named accounts; import institution-approved regulations; rehearse recovery and obtain DSU academic, privacy and security sign-off. See the deployment guide for the exact steps. The preview has no official attendance, examination, payment, email or identity-provider integration.

### Ready-to-use workbooks
`templates/` contains all nine blank Excel templates. In the synthetic preview, try **Super Administrator → Workspace settings → Data imports → Student master** with `examples/synthetic-student-import.xlsx`. Validate first; one clearly synthetic student is added only after confirmation. A repeated import is reported as a duplicate unless reviewed updates are explicitly authorised.

### Pilot sign-in (1.0.1)
If the preview shows the entrance screen, select **Explore the Dean workspace**. No username or password is required. The browser uses a scoped application session header so normal preview gateways do not consume its credential. Named-account login is available separately.

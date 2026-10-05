# LockedIN — E2E Test Infrastructure & Test Strategy Specification

**Document Version**: 1.0.0  
**Target Application**: LockedIN Personal Discipline & Consistency Web Application  
**Authoritative Sources**: `ORIGINAL_REQUEST.md`, `PROJECT.md`, `survey_spec_report.md`  
**Test Suite Path**: `tests/e2e/`  
**Runner Executable**: `tests/run-e2e-tests.js` (with companion `tests/run-e2e-tests.ps1`)  

---

## 1. Test Philosophy

### 1.1 Opaque-Box & Requirement-Driven Testing
The LockedIN E2E test framework enforces strict **opaque-box** testing derived purely from `ORIGINAL_REQUEST.md` and `PROJECT.md`. Tests observe only externally verifiable contracts:
- Function inputs, outputs, and return values.
- Persisted state representations in the abstracted `storageService.js` layer.
- Mathematical integrity of the 0–100 Consistency Score formula, multi-tier streak algorithms, and 5-branch missed task recovery actions.
- Schema compliance of all stored entities (`Task`, `Completion`, `Goal`, `Challenge`, `FocusSession`, `Reflection`, `StreakData`, `Settings`).
- Component prop contracts and rendered accessibility landmarks.
- Export/Import JSON data roundtrip integrity without corruption or loss.

### 1.2 Zero Internal Design Bias
Tests must never assume internal implementation secrets or private helper variables. If an implementation changes its internal state management or refactors a helper function, the tests must continue to pass as long as the specification contracts in `ORIGINAL_REQUEST.md` and `PROJECT.md` are upheld.

### 1.3 Progressive Testability & Defect Escalation
As test writers:
1. We write and modify **test code only** — never implementation code.
2. Any bug discovered in the application implementation during test execution is formally logged as an **escalation** with reproduction steps.
3. Tests run without flaky timeouts, relying on deterministic assertions and fixture factories.

---

## 2. Test Architecture & Runner Specification

### 2.1 Directory Layout
```
locked IN/
├── tests/
│   ├── run-e2e-tests.js           # Primary automated test runner (Node.js native, 0 external deps)
│   ├── run-e2e-tests.ps1          # Companion PowerShell test runner for Windows 10
│   ├── helpers/
│   │   ├── assert.js              # Assertion library with deep equality & diff reporting
│   │   ├── mockStorage.js         # In-memory localStorage simulator for storageService
│   │   └── fixtures.js            # Deterministic fixtures for tasks, completions, goals, etc.
│   └── e2e/
│       ├── contracts-storage.test.js  # StorageService API contract & schema validation
│       ├── calculations.test.js       # Consistency score, streaks, at-risk, recovery engine
│       ├── tier1-features.test.js     # Tier 1: Core Feature Coverage (all 60 features)
│       ├── tier2-boundaries.test.js   # Tier 2: Boundaries, edge cases, quota overflow, stress
│       ├── tier3-interactions.test.js # Tier 3: Pairwise cross-feature interactions
│       └── tier4-scenarios.test.js    # Tier 4: Real-world user lifecycle workflows (5+ workflows)
```

### 2.2 Invocation & CLI Semantics
The test suite can be run directly from terminal:

```powershell
# Via Node.js:
node tests/run-e2e-tests.js

# Or via PowerShell runner:
powershell -ExecutionPolicy Bypass -File tests/run-e2e-tests.ps1
```

### 2.3 Pass/Fail Semantics & Output Reporting
- **Exit Code 0**: All executed test suites and assertions passed cleanly.
- **Exit Code 1**: At least one test assertion failed, or a test file threw an unhandled exception.
- **Reporting**:
  - Detailed suite headers with test counts.
  - Per-test pass (`✓`) / fail (`✗`) status with execution time.
  - Failure diff output detailing `expected` vs `actual`.
  - Tier-by-tier coverage summary table at the conclusion.

---

## 3. Coverage Thresholds & Hierarchy

| Tier | Name | Target Ratio | Description |
|---|---|---|---|
| **Tier 1** | Feature Coverage | $\ge 5$ tests per feature | Verifies happy-path execution, data creation, retrieval, and status transitions for all 60 features. |
| **Tier 2** | Boundary & Corner Cases | $\ge 5$ tests per feature | Verifies edge conditions: empty inputs, midnight rollovers, leap years, 0/0 divisions, quota errors, corrupt JSON recovery. |
| **Tier 3** | Cross-Feature Interactions | Exhaustive pairwise combinations | Verifies integrated state propagation across subsystems (e.g. Task Complete $\to$ Streak $\to$ Consistency $\to$ Chart $\to$ History $\to$ Achievement). |
| **Tier 4** | Real-World Application Scenarios | $\ge 5$ complex workflows | End-to-end multi-day simulations representing authentic user lifecycles over extended durations. |

---

## 4. Comprehensive 60-Feature Inventory Mapping

All 60 features identified in `PROJECT.md` are systematically mapped to verification criteria, tier coverage, and test targets:

| # | Feature Name | Category | Primary Contract Verified | Tiers Covered | Target Test Suite |
|---|--------------|----------|---------------------------|---------------|-------------------|
| 1 | Node/Vite/Tailwind Tooling | Infrastructure | Build configuration, scripts, index.html metadata | T1, T2 | `tier1-features.test.js` |
| 2 | Styling & Theme System | UI / Tokens | Dark default `#0a0b0e`, light mode, crimson `#be123c`, Inter font | T1, T2, T3 | `tier1-features.test.js` |
| 3 | Storage Service Architecture | Persistence | Abstracted `storageService.js` CRUD, zero direct localStorage in UI | T1, T2, T3 | `contracts-storage.test.js` |
| 4 | Task & Habit Data Models | Data Models | Schema validation for all 16 Task fields, priority, frequency | T1, T2 | `contracts-storage.test.js` |
| 5 | Goal & Challenge Models | Data Models | Schemas for Goal, Challenge, 7 pre-built templates | T1, T2 | `contracts-storage.test.js` |
| 6 | Focus & Reflection Models | Data Models | Schemas for FocusSession, Reflection, 4 mood values | T1, T2 | `contracts-storage.test.js` |
| 7 | Multi-tier Streak Calculation | Logic | Current, Longest, Weekly, Monthly streaks, standard vs strict mode | T1, T2, T3 | `calculations.test.js` |
| 8 | Consistency Score Formula | Logic | $0.4C + 0.3Z + 0.2S + 0.1R$ clamped $[0, 100]$, trend evaluation | T1, T2, T3 | `calculations.test.js` |
| 9 | Missed Task Recovery Logic | Logic | 5 branches: Reschedule, Complete later, Skip, Keep missed, Delete | T1, T2, T3 | `calculations.test.js` |
| 10 | 90-day Mock Data Engine | Data | 10 authentic tasks, ~84% consistency, 90-day history spanning 2026-06-22 to 2026-09-20 | T1, T2 | `contracts-storage.test.js` |
| 11 | UI Component Primitives | UI Primitives | Button, Modal, Card, Badge, ProgressBar, Tabs, EmptyState, Tooltip contracts (<300 LOC) | T1, T2 | `tier1-features.test.js` |
| 12 | Sidebar Navigation | Layout | 8 distinct routes, active indicator, collapse states | T1, T2, T3 | `tier1-features.test.js` |
| 13 | Mobile Bottom Navigation | Layout | 5 touch tabs, active states, mobile viewport adaptability | T1, T2 | `tier1-features.test.js` |
| 14 | TopBar & Global Controls | Layout | Current date display, theme toggle trigger, search trigger, quick add | T1, T2 | `tier1-features.test.js` |
| 15 | Routing & Page Shell | Navigation | 8 top-level routes, dynamic switching, no dead ends | T1, T3 | `tier1-features.test.js` |
| 16 | ProgressCard Component | Dashboard | Today's completion percentage ring, completed/total count, dynamic labels | T1, T2, T3 | `tier1-features.test.js` |
| 17 | QuickStats Component | Dashboard | 4-stat cards: Streak, Consistency Score, Completions, Focus Hours | T1, T2, T3 | `tier1-features.test.js` |
| 18 | TodayTasks Component | Dashboard | 3 priority tiers: Must Do, Should Do, Nice To Do, completion toggle | T1, T2, T3 | `tier1-features.test.js` |
| 19 | UpcomingReminders Component | Dashboard | Chronological upcoming tasks with reminder times, empty state | T1, T2 | `tier1-features.test.js` |
| 20 | AtRiskTasks Component | Dashboard | Detection for uncompleted tasks past reminder or hour >= 18:00 | T1, T2, T3 | `calculations.test.js` |
| 21 | NoZeroDayCard Component | Dashboard | Encouragement when completions = 0; celebration when completions >= 1 | T1, T2, T3 | `calculations.test.js` |
| 22 | Tasks Page & TaskList | Tasks | Filtering by All/Today/Daily/Weekly/Monthly/Completed/Missed, sorting | T1, T2, T3 | `tier1-features.test.js` |
| 23 | TaskCard Component | Tasks | Display title, category badge, priority, streak, duration, action menu | T1, T2 | `tier1-features.test.js` |
| 24 | AddTaskModal Component | Tasks | Modal validation: title non-empty, end date >= start date, duration >= 1 | T1, T2, T3 | `tier1-features.test.js` |
| 25 | EditTaskModal Component | Tasks | Update task fields, preserve ID, historical logs, and streak counts | T1, T2, T3 | `tier1-features.test.js` |
| 26 | MissedTaskRecoveryModal | Tasks | Modal executing 5 recovery branches with validation for new dates | T1, T2, T3 | `tier1-features.test.js` |
| 27 | Calendar View & Grid | Calendar | Month matrix (7x5/6), per-day consistency intensity levels | T1, T2, T3 | `tier1-features.test.js` |
| 28 | DayDetails Drawer/Panel | Calendar | Date inspection: completed vs missed breakdown, focus sessions, reflection | T1, T2, T3 | `tier1-features.test.js` |
| 29 | Daily Reflection Modal | Reflection | 4 moods (Low/Okay/Good/Great), "what went well", "improve tomorrow" | T1, T2, T3 | `tier1-features.test.js` |
| 30 | ConsistencyChart (Recharts) | Analytics | LineChart trend over 7D/30D/90D/6M/1Y, tooltip data structure | T1, T2, T3 | `tier1-features.test.js` |
| 31 | CompletedMissedChart (Recharts)| Analytics | Stacked BarChart comparing completed vs missed volume | T1, T2, T3 | `tier1-features.test.js` |
| 32 | CategoryChart (Recharts) | Analytics | Category distribution across 7 canonical Areas of Life | T1, T2, T3 | `tier1-features.test.js` |
| 33 | ActivityHeatmap | Analytics | 90-day intensity grid, 4 shade levels, tooltips | T1, T2 | `tier1-features.test.js` |
| 34 | StreakChart (Recharts) | Analytics | AreaChart of historical streak progression and recovery pass points | T1, T2, T3 | `tier1-features.test.js` |
| 35 | GraphFilters Component | Analytics | Timeframe switcher (7D, 30D, 90D, 6M, 1Y), category toggle | T1, T2 | `tier1-features.test.js` |
| 36 | FocusTimer Component | Focus | Countdown & stopwatch, presets (15, 25, 45, 60m), elapsed time precision | T1, T2, T3 | `tier1-features.test.js` |
| 37 | FocusStats Component | Focus | Today, Week, Month focus hours, session counters, category breakdown | T1, T2, T3 | `tier1-features.test.js` |
| 38 | ChallengeCard Component | Challenges | Progress tracking (Day X of Y), completion percentage, status | T1, T2, T3 | `tier1-features.test.js` |
| 39 | ChallengeTemplates Component | Challenges | 7 templates: 30D Discipline, Reading, Workout, Study, No Zero, Morning, Detox | T1, T2 | `tier1-features.test.js` |
| 40 | ChallengeModal Component | Challenges | Custom challenge builder: Title, duration > 0, start date, target rules | T1, T2, T3 | `tier1-features.test.js` |
| 41 | GoalCard Component | Goals | Target date countdown, linked commitments count, dynamic progress bar | T1, T2, T3 | `tier1-features.test.js` |
| 42 | GoalModal Component | Goals | Goal CRUD with category assignment, target date validation | T1, T2, T3 | `tier1-features.test.js` |
| 43 | Weekly Planning View | Planning | 7-day schedule grid, task assignment to weekdays, weekly review summary | T1, T2, T3 | `tier1-features.test.js` |
| 44 | ActivityTimeline Component | History | Chronological feed of user events with icons, timestamps, metadata | T1, T2, T3 | `tier1-features.test.js` |
| 45 | HistoryFilters Component | History | Filtering by event type (task, focus, reflection, challenge, goal) | T1, T2 | `tier1-features.test.js` |
| 46 | Achievements Badges System | Gamification | 9 unlockable badges, milestone thresholds, unlocked dates | T1, T2, T3 | `tier1-features.test.js` |
| 47 | Areas of Life Management | Categorization | 7 canonical categories: Study, Fitness, Health, Career, Finance, Learning, Personal | T1, T2 | `tier1-features.test.js` |
| 48 | Quick Add Floating Button | Global UI | Floating '+' speed-dial opening Task, Goal, Challenge, Focus, Reflection modals | T1, T2 | `tier1-features.test.js` |
| 49 | Global Search Modal | Global UI | Cmd/Ctrl+K search querying Tasks, Goals, Challenges, History with regex safety | T1, T2, T3 | `tier1-features.test.js` |
| 50 | Notification UI Drawer | Notifications | In-app reminder drawer, upcoming alerts, streak preservation warnings | T1, T2 | `tier1-features.test.js` |
| 51 | Settings Page | Settings | Preferences: theme, week start (Mon/Sun), default reminder, sound | T1, T2, T3 | `tier1-features.test.js` |
| 52 | Data Export / Import / Clear | Data Lifecycle | JSON backup download, schema-validated JSON restore, factory reset | T1, T2, T3 | `contracts-storage.test.js` |
| 53 | Onboarding 6-Screen Flow | Onboarding | 6-screen step machine, completion persistence, subsequent bypass | T1, T2, T3 | `tier1-features.test.js` |
| 54 | Empty States & Micro-interactions | Polish | Informative empty states with CTAs across all major views | T1, T2 | `tier1-features.test.js` |
| 55 | E2E Test Suite (Tiers 1-4) | QA | Comprehensive test harness executing all suites with pass/fail exit codes | T1-T4 | All suites |
| 56 | Adversarial Hardening (Tier 5) | Reliability | Quota limits, corrupted JSON, null injection, boundary conditions | T2 | `tier2-boundaries.test.js` |
| 57 | Build & Asset Verification | Build | Zero warnings/errors during Vite production build | T1 | `tier1-features.test.js` |
| 58 | Responsive Polish (1440/768/390)| UI Polish | Desktop multi-col, tablet sidebar, mobile bottom nav layout rules | T1, T2 | `tier1-features.test.js` |
| 59 | Code Quality & LOC Compliance | Architecture | Every component file < 300 LOC, zero direct localStorage in UI | T1, T2 | `tier1-features.test.js` |
| 60 | Forensic Integrity Verification | Audit | Zero dummy stubs, verified mathematical implementations | T1-T4 | All suites |

---

## 5. Real-World Application Scenarios (Tier 4)

Tier 4 tests model complex, multi-day user journeys simulating authentic discipline lifecycles:

### Scenario 1: New User Onboarding to First Week Momentum
1. User launches application with fresh state (`onboardingCompleted: false`).
2. Completes 6-screen onboarding: Selects areas ('Study', 'Fitness'), sets commitment level 'High', inputs goal 'Master Algorithms', creates first task 'Morning Algorithm Practice' (Critical, Daily, 07:00).
3. Lands on Dashboard; verifies ProgressCard shows 0/1 (0%).
4. Toggles first task completed $\to$ ProgressCard updates to 100%, No Zero Day card unlocks celebratory status, Current Streak becomes 1, 'First Commitment' achievement unlocks.
5. Simulates 6 subsequent consecutive days of 100% completions:
   - Day 7: Streak reaches 7, unlocking '7-Day Streak' achievement.
   - Consistency Score reflects high completion rate ($C=100, Z=100, S=50, R=100 \implies 90+$).
   - ActivityHeatmap shows 7 consecutive shaded active cells.

### Scenario 2: High Performer Missed Day & Recovery Pass Utilization
1. User has established a 21-day streak with 3 recovery passes available.
2. Day 22 arrives and passes with 0 completions (unforeseen travel).
3. On Day 23 morning, user opens app:
   - Evaluates at-risk/missed tasks.
   - User applies a **Recovery Pass** to Day 22 via Calendar DayDetails drawer.
   - Recovery pass decrements to 2 remaining, Day 22 status transitions to `protected`.
   - 21-day streak is successfully preserved and increments to 22 upon completing Day 23's tasks.
   - ActivityTimeline logs `recovery_used` event with timestamp and reason.

### Scenario 3: Missed Task 5-Branch Recovery Workflow
1. User fails to complete 5 scheduled commitments on a given day.
2. User executes each of the 5 distinct recovery options across the 5 tasks:
   - **Task A (Reschedule)**: Rescheduled to tomorrow (`YYYY-MM-DD + 1`). Original marked `rescheduled`; new task instance scheduled.
   - **Task B (Complete Later)**: Marked completed with `late: true`. Timestamp recorded.
   - **Task C (Mark Intentionally Skipped)**: User inputs skip reason ("Rest day"). Marked `skipped`; exempt from severe score penalty.
   - **Task D (Keep Missed)**: User retains `missed` status for honest accountability.
   - **Task E (Delete)**: Task removed cleanly from active schedule.
3. System verifies Consistency Score calculates resilience component ($R$) accurately based on recovered vs pure missed tasks.

### Scenario 4: Deep Work Focus Session & Goal Progress Integration
1. User creates long-term Goal: "Senior Promotion & Architecture" with deadline in 60 days.
2. Creates Task: "System Architecture Deep Work" linked to the Goal (`goalId`).
3. Launches Focus Mode:
   - Selects "System Architecture Deep Work" from task selector.
   - Sets 50-minute Pomodoro preset.
   - Starts timer, simulates running, pause/resume, and finishes session.
4. Storage records `FocusSession` (50 mins, linked task ID, completed: true).
5. FocusStats reflects: Today's focus time +50m, Total sessions +1, Category 'Career' +50m.
6. Completing the linked task automatically triggers `recalculateGoalProgress()` and updates the GoalCard progress bar.

### Scenario 5: Full Data Lifecycle: Multi-Month Export, Reset, and Restored Fidelity
1. User runs LockedIN with 90-day mock dataset (10 tasks, 4 goals, 3 challenges, 65 focus sessions, 15 reflections).
2. User modifies settings, creates 2 custom tasks, and logs a daily reflection.
3. Executes `exportAllData()`, generating a valid JSON backup string.
4. Executes `clearAllData()` (factory reset):
   - All tasks, completions, streaks, and reflections are wiped.
   - Storage returns to clean state; onboarding flag reset.
5. Executes `importAllData(backupJson)`:
   - Validates root schema and all entity arrays.
   - Restores complete state with 100% data fidelity.
   - Streak data, consistency score, and focus sessions match pre-export state exactly.

---

## 6. Execution Command Reference

```powershell
# Direct Node runner
node tests/run-e2e-tests.js

# Target specific test suites
node tests/run-e2e-tests.js --suite=contracts
node tests/run-e2e-tests.js --suite=calculations
node tests/run-e2e-tests.js --suite=tier1
node tests/run-e2e-tests.js --suite=tier2
node tests/run-e2e-tests.js --suite=tier3
node tests/run-e2e-tests.js --suite=tier4
```

This specification establishes the authoritative testing foundation for LockedIN, ensuring zero regression and complete requirement conformance.

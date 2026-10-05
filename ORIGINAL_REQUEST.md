# Original User Request

## 2026-09-20T15:46:23Z

Build **LockedIN** — a premium, production-quality, frontend-only personal discipline and consistency web application. LockedIN helps users plan their day, create daily/weekly/monthly commitments, build streaks, track consistency, review performance, and improve over time. It should feel like a personal operating system for discipline — calm, focused, and premium. The core loop is: Plan → Execute → Track → Review → Improve → Repeat.

**Tech stack**: React, Vite, Tailwind CSS, JavaScript/JSX, localStorage for persistence. No backend, no external databases, no authentication servers.

Working directory: `c:\Users\Windows-10\Desktop\Antigravity projects\locked IN`
Integrity mode: development

## Requirements

### R1. Complete Feature Set

Build all features described in the reference specification below. The application must include:

- **Onboarding**: 6-screen guided flow (welcome → interest selection → goal input → commitment level → first task creation → summary). Persisted via localStorage.
- **Dashboard**: Central command center with today's progress visualization, quick stats (streak, consistency, tasks completed), today's commitments organized by priority tier (Must Do / Should Do / Nice To Do), upcoming reminders, at-risk tasks, and a No Zero Day encouragement card.
- **Tasks**: Full task management with CRUD operations, search, sorting, filtering (All/Today/Daily/Weekly/Monthly/Completed/Missed), task cards showing title/description/category/frequency/priority/reminder/streak/completion rate, and actions (Complete/Edit/Pause/Delete). Create task via polished modal with fields for name, description, category, priority (Critical/High/Normal/Low), frequency (Daily/Specific days/Weekly/Monthly/Custom), reminder, dates, estimated duration.
- **Calendar**: Premium monthly calendar view with per-day consistency visualization (high/medium/low/missed/none using subtle intensity, not large colored circles). Click a date to see completed/missed breakdown with percentage.
- **Graphs page**: 6 chart types — Consistency Trend (line), Completed vs Missed (bar), Category Performance (bar), Daily Activity Heatmap (~90 days), Weekly Performance (line/bar), Streak History. Timeframe selector (7D/30D/90D/6M/1Y). Use **Recharts** for all charts. Interactive hover states.
- **Challenges**: Templates (30 Day Discipline, Reading, Workout, Study Streak, No Zero Days, Early Morning, Digital Detox) plus custom challenge creation. Progress tracking per challenge.
- **Focus Mode**: Task selection → timer (Pause/Resume/Finish) → session recording. Stats for today/week/month focus time.
- **Goals**: Goal creation (name, description, target date) with linked commitments and visual progress tracking.
- **Weekly Planning**: 7-day view with task assignment to days, planned/completed/missed status, and weekly review summary.
- **Daily Reflection**: End-of-day mood selector (Low/Okay/Good/Great) with "What went well?" and "What should improve tomorrow?" text inputs.
- **History**: Complete activity timeline with filtering (All/Completed/Missed/Rescheduled/Focus/Challenges).
- **Streaks**: Current/Longest/Best Weekly/Best Monthly streak tracking. Recovery Pass system (limited passes to protect streaks on missed days — no monetization).
- **Missed Task Recovery**: Options for Reschedule/Complete later/Mark intentionally skipped/Keep missed/Delete. Recorded in history.
- **Consistency Score**: 0-100 score based on completion, consistency, streak, and recovery metrics. Show breakdown. Framed as app-activity metric only.
- **Achievements**: Unlockable achievements (First Commitment, 7/30 Day Streak, 100/250 Tasks, No Zero Day, Comeback, Challenge Complete, 100 Focus Hours). Subtle, non-childish design.
- **Areas of Life**: Categories (Study/Fitness/Health/Career/Finance/Learning/Personal) that tasks belong to, filterable in analytics.
- **Quick Add**: Global floating + button available on major screens with options for Task/Goal/Challenge/Focus session/Reflection.
- **Global Search**: Search across Tasks/Goals/Challenges/History.
- **Notification UI**: Frontend-only reminder configuration (set time, enable/disable, choose behavior: once/until completed). No real push notifications.
- **Settings**: Theme (Dark/Light/System), week start day, reminder defaults, streak/recovery/completion/missed-task settings, data export/import/clear, about section.

### R2. Design System and Brand Identity

The application name is **LockedIN** (exact capitalization). Supporting tagline: "Plan less. Do more. Stay consistent." (used sparingly).

**Dark mode** (default): near-black background, dark charcoal surfaces, subtle charcoal elevated cards, off-white primary text, muted gray secondary text, very subtle gray borders. **Light mode**: warm/neutral white background, charcoal text, subtle gray borders. Both modes share the same accent system.

**Accent colors**: Deep crimson/restrained red (primary accent — used strategically, not everywhere), muted green (success), muted amber (warning), muted red (danger).

**Typography**: Use **Inter** (or Geist) as the primary font. Clear hierarchy: large for page titles, medium for section headings, small for metadata. Careful font-weight usage — not everything bold.

**Design feel**: Premium, minimal, sophisticated, spacious, clean. Inspired by Linear/Apple/Notion/Arc quality level — NOT copies. Subtle borders, soft shadows, smooth micro-interactions. No excessive gradients, glassmorphism, glowing elements, cartoon graphics, excessive emojis, or gaming-style UI. Should NOT feel like a basic todo list, children's habit tracker, or generic productivity dashboard.

### R3. Component Architecture and Data Model

Follow this exact component and file structure:

```
src/
  components/
    layout/        — Sidebar, MobileNavigation, TopBar
    dashboard/     — ProgressCard, QuickStats, TodayTasks, UpcomingReminders, AtRiskTasks
    tasks/         — TaskCard, TaskList, TaskFilters, AddTaskModal, EditTaskModal
    calendar/      — Calendar, DayDetails
    graphs/        — ConsistencyChart, CompletedMissedChart, CategoryChart, ActivityHeatmap, StreakChart, GraphFilters
    challenges/    — ChallengeCard, ChallengeTemplates, ChallengeModal
    focus/         — FocusTimer, FocusStats
    goals/         — GoalCard, GoalModal
    history/       — ActivityTimeline, HistoryFilters
    reflection/    — ReflectionModal
    ui/            — Button, Modal, Card, Badge, ProgressBar, Tabs, EmptyState, Tooltip
  pages/           — Dashboard, Tasks, Calendar, Graphs, Challenges, Focus, History, Settings
  data/            — mockData
  utils/           — calculations, dateUtils, storage
  services/        — storageService.js (abstracted data access)
```

**Data models** must include these entities with at minimum the specified fields:

- **Task**: `{ id, title, description, category, priority, frequency, reminderTime, startDate, endDate, estimatedDuration, status, streak, completionRate, goalId }`
- **Completion**: `{ id, taskId, date, status, completedAt }`
- **Goal**: `{ id, title, description, targetDate, progress }`
- **Challenge**: `{ id, title, duration, startDate, progress, status }`
- **FocusSession**: `{ id, taskId, duration, date, completed }`
- **Reflection**: `{ id, date, mood, wentWell, improveTomorrow }`

### R4. localStorage Persistence with Backend-Ready Abstraction

All application data (tasks, completions, goals, challenges, focus sessions, reflections, settings, onboarding status) must persist in localStorage and survive browser refresh.

**Critical architecture rule**: All data access must go through an abstracted storage service (`services/storageService.js`). No component may directly call `localStorage`. This service layer must be structured so it can later be replaced by `apiService.js` or `supabaseService.js` without modifying UI components.

### R5. Responsive Design, Accessibility, and Polish

**Responsive breakpoints**: Desktop (1440px) — sidebar + multi-column dashboard. Laptop (1280px). Tablet (768px) — collapsible sidebar. Mobile (390px) — bottom navigation, single-column cards, mobile-friendly modals, touch-friendly controls.

**Desktop navigation**: Left sidebar with logo, nav items (Dashboard/Tasks/Calendar/Graphs/Challenges/Focus/History/Settings), and profile section at bottom.

**Mobile navigation**: Compact top nav + bottom nav (Home/Tasks/Graphs/Calendar/More).

**Accessibility**: Semantic HTML, keyboard navigation, accessible buttons, visible focus states, readable contrast, ARIA labels. Do not rely on color alone for task status.

**Animations**: Subtle and fast — page transitions, checkbox completion, progress updates, modal opening, task creation/deletion, chart appearance, streak celebration. Respect `prefers-reduced-motion`.

**Empty states**: Every major section (Tasks, Calendar, Challenges, Goals, History, Graphs) must have a useful empty state with a call to action.

**Error/edge handling**: No tasks, no completed tasks, no graph data, deleted task, invalid inputs, empty titles, invalid dates — never show broken UI.

**Mock data**: Ship with realistic sample data (8-12 tasks across multiple categories/frequencies, completed and missed tasks, active challenges, goals, focus sessions, ~90 days of graph activity). No lorem ipsum.

## Acceptance Criteria

### Build and Runtime
- [ ] `npm install` completes without errors
- [ ] `npm run dev` starts the Vite dev server without errors
- [ ] `npm run build` produces a production build without errors
- [ ] The browser console shows zero errors when navigating through all pages
- [ ] The application renders correctly in a Chromium-based browser

### Feature Completeness
- [ ] All 8 sidebar navigation items (Dashboard, Tasks, Calendar, Graphs, Challenges, Focus, History, Settings) route to distinct, fully functional pages — no placeholder pages
- [ ] Onboarding flow: completing all 6 screens saves onboarding state to localStorage and navigates to Dashboard; subsequent visits skip onboarding
- [ ] Task CRUD: can create a task with all fields (name, description, category, priority, frequency, reminder, dates, duration), edit it, complete it (with visual feedback), undo completion, pause it, and delete it
- [ ] Dashboard: displays today's progress percentage, quick stats, today's commitments grouped by priority tier, upcoming reminders, at-risk tasks, and the No Zero Day card
- [ ] Calendar: monthly view renders with per-day consistency indicators; clicking a date shows completed/missed breakdown; month navigation works
- [ ] Graphs: all 6 chart types render with mock data; timeframe selector changes displayed data; hover states work on charts
- [ ] Challenges: can start a template challenge and create a custom challenge; progress is tracked and displayed
- [ ] Focus Mode: can select a task, start timer, pause/resume, finish; session is recorded; focus stats display accumulated time
- [ ] Goals: can create a goal, link tasks to it, and view progress
- [ ] Weekly Planning: 7-day view with task assignment; shows planned/completed/missed
- [ ] Daily Reflection: mood selector and text inputs work; reflections are saved
- [ ] History: activity timeline shows events; filtering works across all categories
- [ ] Streaks: current and longest streak are calculated and displayed correctly
- [ ] Recovery Pass: can use a recovery pass on a missed day; limited supply
- [ ] Missed Task Recovery: all 5 options (Reschedule/Complete later/Mark skipped/Keep missed/Delete) work
- [ ] Consistency Score: displays a 0-100 score with component breakdown
- [ ] Achievements: at least 5 achievements unlock based on actual app activity
- [ ] Global Search: returns results from tasks, goals, challenges, and history
- [ ] Quick Add: floating button on major screens opens creation options
- [ ] Settings: theme toggle (Dark/Light/System) works and persists; data export/import/clear functions work
- [ ] Notification UI: can set reminder time and behavior on tasks (frontend only)

### UI / UX Quality
- [ ] Dark mode is the default; light mode is visually consistent (not broken or unstyled)
- [ ] The Inter (or Geist) font is loaded and used throughout
- [ ] Accent color (deep crimson) is used strategically — not applied broadly across the entire interface
- [ ] Typography hierarchy is clear: distinct visual weight for page titles, section headings, and metadata
- [ ] No excessive gradients, glassmorphism, glowing elements, or cartoon graphics
- [ ] Animations are present on key interactions (checkbox, modals, progress updates) and respect `prefers-reduced-motion`
- [ ] Every section with potentially no data shows a useful empty state with a call to action

### Data Persistence
- [ ] Creating a task, refreshing the browser, and returning shows the task still present
- [ ] Completing a task, refreshing the browser, and returning shows the task still completed
- [ ] Settings changes (theme, preferences) persist across refresh
- [ ] Onboarding completion persists across refresh
- [ ] No component directly calls `localStorage` — all access goes through `storageService.js`

### Responsive Design
- [ ] At 1440px: sidebar visible, multi-column dashboard layout
- [ ] At 768px: sidebar collapses or transitions to mobile navigation
- [ ] At 390px: bottom navigation visible, single-column layout, modals are mobile-friendly
- [ ] No horizontal overflow or broken layouts at any tested breakpoint

### Code Quality
- [ ] File structure matches the specified component architecture (R3)
- [ ] Data models include all specified fields
- [ ] No single component file exceeds ~300 lines (components are properly decomposed)
- [ ] Reusable UI components (Button, Modal, Card, etc.) are used consistently — not re-implemented inline
- [ ] Mock data is realistic (real task names like "Study Pharmacology", "Workout", "Read 20 pages" — no lorem ipsum)

## Verification

Run these checks after build:

```bash
# 1. Install and build
cd "c:\Users\Windows-10\Desktop\Antigravity projects\locked IN"
npm install
npm run build

# 2. Start dev server and verify no console errors
npm run dev

# 3. Verify file structure matches R3
# Check that src/components/layout, src/components/dashboard, src/services/storageService.js etc. exist

# 4. Verify no direct localStorage calls in components
# grep -r "localStorage" src/components/ should return zero results
# grep -r "localStorage" src/services/ should return results (only in storageService)

# 5. Verify responsive breakpoints by resizing browser
# 6. Verify localStorage persistence by creating a task, refreshing, confirming it persists
# 7. Toggle dark/light mode and confirm both render correctly
# 8. Navigate to every sidebar item and confirm no placeholder pages
```

## Follow-up — 2026-09-21T10:24:54Z

**CONTINUATION BUILD** — Resume building **LockedIN** from Milestone 2 onward. Milestone 1 is fully complete and verified.

## Current State (M1 Complete)

The following is already built and working in the workspace:
- Vite 5.4 + React 18.3 + Tailwind 3.4 project scaffolded and building
- All npm dependencies installed (react, react-dom, recharts, lucide-react, canvas-confetti, clsx, tailwind-merge)
- `npm run build` produces `dist/` successfully
- Tailwind config with full dark/light design token system (crimson accent, zinc charcoal surfaces)
- Inter font configured
- All 15 R3 directory structures created under `src/components/`
- `src/utils/cn.js` utility exists
- `src/App.jsx` exists (177 lines, M1 verification page — will be replaced with real app shell)
- `src/main.jsx` and `src/index.css` exist
- `package.json`, `vite.config.js`, `tailwind.config.js`, `postcss.config.js`, `jsconfig.json` all configured
- `react-router-dom` is NOT yet installed — you will need to add it

## What Needs to Be Built (M2–M6)

Refer to the PROJECT.md in the working directory for the complete 60-feature inventory, interface contracts, and code layout. Here is the summary:

### M2: Storage Service & Mock Data Engine
- `src/services/storageService.js` — complete abstraction layer with 40+ methods (see Interface Contracts in PROJECT.md)
- `src/data/mockData.js` — realistic 90-day mock dataset (10+ tasks, completions, goals, challenges, focus sessions, reflections)
- `src/utils/calculations.js` — consistency score, streak calculations, completion rates
- `src/utils/dateUtils.js` — date formatting, comparison, range utilities
- **Critical rule**: Zero direct `localStorage` calls anywhere except `storageService.js`

### M3: UI Primitives & Responsive Layout
- `src/components/ui/` — Button, Modal, Card, Badge, ProgressBar, Tabs, EmptyState, Tooltip
- `src/components/layout/Sidebar.jsx` — desktop 256px pinned nav (Dashboard/Tasks/Calendar/Graphs/Challenges/Focus/History/Settings)
- `src/components/layout/MobileNavigation.jsx` — mobile bottom nav (Home/Tasks/Graphs/Calendar/More)
- `src/components/layout/TopBar.jsx` — header with date, theme toggle, quick add, search
- React Router setup with all 8 page routes
- Replace current App.jsx with real app shell (sidebar + content area + routing)

### M4: Core Productivity Modules
- **Dashboard page**: ProgressCard, QuickStats, TodayTasks (grouped by Must Do/Should Do/Nice To Do), UpcomingReminders, AtRiskTasks, NoZeroDayCard
- **Tasks page**: TaskList with search/filter/sort, TaskCard, AddTaskModal, EditTaskModal, MissedTaskRecoveryModal
- **Calendar page**: Monthly grid with consistency indicators, DayDetails panel
- **Reflection**: ReflectionModal with mood selector and text inputs

### M5: Advanced Engagement Modules
- **Graphs page**: 6 Recharts charts (ConsistencyChart, CompletedMissedChart, CategoryChart, ActivityHeatmap, StreakChart, WeeklyPerformance) with GraphFilters
- **Focus page**: FocusTimer (select task, countdown, pause/resume/finish), FocusStats
- **Challenges page**: ChallengeCard, ChallengeTemplates (7 templates), ChallengeModal
- **Goals page**: GoalCard, GoalModal with linked tasks
- **History page**: ActivityTimeline, HistoryFilters
- **Weekly Planning**: 7-day view with task assignment
- **Settings page**: Theme toggle, week start day, reminder defaults, data export/import/clear
- **Onboarding**: 6-screen flow (welcome → interests → goal → commitment level → first task → summary)
- **Search**: GlobalSearchModal (Cmd+K)
- **Quick Add**: Floating action button
- **Achievements**: Badge system
- **Notification UI**: Reminder configuration drawer

### M6: Testing & Polish
- All features working end-to-end
- localStorage persistence verified (survives refresh)
- Responsive at 1440px / 768px / 390px
- Dark and light modes both fully styled
- Empty states for all sections
- No console errors
- No broken UI on edge cases
- Every button functional
- `npm run build` passes cleanly

## Design System (Already Configured in tailwind.config.js)
- **Dark mode** (default): `#09090B` bg, `#18181B` surface/card, `#27272A` border/elevated, `#F4F4F5` text, `#A1A1AA` secondary text
- **Light mode**: `#FAFAFA` bg, `#FFFFFF` surface, `#E4E4E7` border, `#18181B` text
- **Accent**: Crimson `#E11D48` (primary), `#BE123C` (hover), `#991B1B` (active)
- **Status**: Success `#10B981`, Warning `#F59E0B`, Danger `#EF4444`
- **Font**: Inter
- **Shadows**: subtle, elevated, crimson-subtle
- **Animations**: fade-in, scale-in, pulse-subtle

## Brand
- Name: **LockedIN** (exact capitalization)
- Tagline: "Plan less. Do more. Stay consistent." (use sparingly)
- Feel: Premium, minimal, calm, focused — like a personal operating system for discipline
- NOT: basic todo list, children's habit tracker, gaming app

## Data Models (minimum fields)
- **Task**: `{ id, title, description, category, priority, frequency, reminderTime, startDate, endDate, estimatedDuration, status, streak, completionRate, goalId }`
- **Completion**: `{ id, taskId, date, status, completedAt }`
- **Goal**: `{ id, title, description, targetDate, progress }`
- **Challenge**: `{ id, title, duration, startDate, progress, status }`
- **FocusSession**: `{ id, taskId, duration, date, completed }`
- **Reflection**: `{ id, date, mood, wentWell, improveTomorrow }`

## Key Architecture Rules
1. No component file > 300 lines
2. All localStorage access through `storageService.js` only
3. Reusable UI components used consistently (not re-implemented inline)
4. Mock data must be realistic ("Study Pharmacology", "Workout", "Read 20 pages" — no lorem ipsum)
5. Clean separation: data logic in utils/services, UI in components
6. The storageService must be structured so it can be swapped for an API service later

Working directory: `c:\Users\Windows-10\Desktop\Antigravity projects\locked IN`
Integrity mode: development

## Acceptance Criteria

### Build and Runtime
- [ ] `npm run dev` starts without errors
- [ ] `npm run build` produces production build without errors
- [ ] Zero console errors when navigating all pages

### Feature Completeness
- [ ] All 8 sidebar nav items route to distinct, fully functional pages — no placeholders
- [ ] Onboarding: 6 screens, saves state, skips on return
- [ ] Task CRUD: create/edit/complete/undo/pause/delete all work
- [ ] Dashboard: progress %, quick stats, priority-grouped tasks, reminders, at-risk, No Zero Day
- [ ] Calendar: monthly view with consistency indicators, date click shows details, month navigation
- [ ] Graphs: all 6 chart types render with data, timeframe selector works, hover states
- [ ] Challenges: start template, create custom, track progress
- [ ] Focus: select task, timer with pause/resume/finish, session recorded, stats shown
- [ ] Goals: create, link tasks, view progress
- [ ] Weekly Planning: 7-day view with task assignment
- [ ] Reflection: mood + text inputs, saved to storage
- [ ] History: timeline with filtering
- [ ] Streaks: current/longest calculated correctly
- [ ] Recovery Pass: use on missed day, limited supply
- [ ] Missed Task Recovery: all 5 options work
- [ ] Consistency Score: 0-100 with breakdown
- [ ] Achievements: 5+ unlock based on activity
- [ ] Global Search: results from tasks/goals/challenges/history
- [ ] Quick Add: floating button on major screens
- [ ] Settings: theme toggle persists, data export/import/clear works
- [ ] Notification UI: set reminder time and behavior

### UI/UX Quality
- [ ] Dark mode default, light mode consistent
- [ ] Inter font loaded and used
- [ ] Crimson accent used strategically, not everywhere
- [ ] Clear typography hierarchy
- [ ] Animations on key interactions, respect prefers-reduced-motion
- [ ] Empty states with CTAs in every section

### Data Persistence
- [ ] Tasks survive browser refresh
- [ ] Completions survive refresh
- [ ] Settings persist
- [ ] Onboarding persists
- [ ] No direct localStorage calls outside storageService.js

### Responsive
- [ ] 1440px: sidebar + multi-column
- [ ] 768px: collapsed sidebar / mobile nav
- [ ] 390px: bottom nav, single column, mobile-friendly modals
- [ ] No horizontal overflow at any breakpoint

### Code Quality
- [ ] File structure matches R3 layout
- [ ] No component > ~300 lines
- [ ] Reusable UI components used consistently
- [ ] Realistic mock data

## 2026-09-21T17:35:06Z

**CONTINUATION BUILD** — Resume building **LockedIN** from Milestone 4 onward. Milestones 1-3 are fully complete, verified, and building successfully.

## Current State (M1-M3 Complete)

`npm run build` passes (1613 modules, 22s). The following 38 source files exist:

**M2 — Storage & Data (complete):**
- `src/services/storageService.js` (unified facade, 40+ methods)
- `src/services/storageCore.js`, `completionStorage.js`, `taskStorage.js`, `engagementStorage.js`, `lifecycleStorage.js`, `metaStorage.js`
- `src/data/mockConstants.js`, `mockGenerators.js`, `mockData.js` (90-day realistic dataset)
- `src/utils/calculations.js`, `dateUtils.js`, `constants.js`, `cn.js`

**M3 — UI Primitives & Layout (complete):**
- `src/components/ui/` — Button (91 LOC), Modal (177 LOC), Card (109 LOC), Badge, ProgressBar, Tabs, EmptyState, Tooltip + index.js
- `src/components/layout/` — Sidebar (174 LOC, 256px pinned), MobileNavigation (156 LOC, bottom nav), TopBar (132 LOC) + index.js
- `src/pages/` — Dashboard, Tasks, Calendar, Graphs, Challenges, Focus, History, Settings + index.js (all page shells)
- `src/App.jsx` (178 LOC) — HashRouter shell with theme sync via storageService

**Tech stack installed:** react, react-dom, react-router-dom, recharts, lucide-react, canvas-confetti, clsx, tailwind-merge, vite, tailwindcss

## What Needs to Be Built (M4–M6)

Refer to PROJECT.md in the working directory for full feature inventory and interface contracts.

### M4: Core Productivity Modules
Replace the page shells with full implementations:

- **Dashboard page** (`src/pages/Dashboard.jsx`): Build these components in `src/components/dashboard/`:
  - `ProgressCard.jsx` — Today's completion percentage with visual ring/bar, tasks done/total
  - `QuickStats.jsx` — 4-card grid: Consistency Score, Current Streak, Total Completions, Focus Hours
  - `TodayTasks.jsx` — Grouped by priority tiers (Must Do / Should Do / Nice To Do) with checkbox completion, undo, recovery
  - `UpcomingReminders.jsx` — Next reminders with times
  - `AtRiskTasks.jsx` — Tasks not completed in 2+ days or approaching deadline
  - `NoZeroDayCard.jsx` — Encouragement when 0 tasks done, celebration when ≥ 1

- **Tasks page** (`src/pages/Tasks.jsx`): Build in `src/components/tasks/`:
  - `TaskList.jsx` — Full list with search, filter tabs (All/Today/Daily/Weekly/Monthly/Completed/Missed), sorting
  - `TaskCard.jsx` — Rich card with checkbox, title, category badge, priority, streak, frequency, action menu
  - `TaskFilters.jsx` — Filter bar with sort options (Priority/Due time/Completion rate/Recently created)
  - `AddTaskModal.jsx` — Create task: name, description, category, priority (Critical/High/Normal/Low), frequency (Daily/Specific days/Weekly/Monthly/Custom), reminder, dates, estimated duration
  - `EditTaskModal.jsx` — Edit task with all fields + pause option
  - `MissedTaskRecoveryModal.jsx` — 5 options: Reschedule/Complete later/Mark skipped/Keep missed/Delete

- **Calendar page** (`src/pages/Calendar.jsx`): Build in `src/components/calendar/`:
  - `Calendar.jsx` (or `CalendarGrid.jsx`) — Monthly grid with per-day consistency indicators (subtle intensity, not big circles). Month navigation.
  - `DayDetails.jsx` — Panel showing completed/missed tasks, percentage, for a clicked date

- **Reflection** in `src/components/reflection/`:
  - `ReflectionModal.jsx` — Mood selector (Low/Okay/Good/Great) + "What went well?" + "What should improve tomorrow?" text inputs. Saved via storageService.

### M5: Advanced Engagement Modules

- **Graphs page** (`src/pages/Graphs.jsx`): Build in `src/components/graphs/`:
  - `ConsistencyChart.jsx` — Line chart, completion % over time (Recharts)
  - `CompletedMissedChart.jsx` — Bar chart, completed vs missed per week
  - `CategoryChart.jsx` — Bar chart, completion % by category (Study/Fitness/Health/Career/Personal)
  - `ActivityHeatmap.jsx` — GitHub-style 90-day heatmap with tooltips
  - `StreakChart.jsx` — Streak progression over time
  - `GraphFilters.jsx` — Timeframe selector (7D/30D/90D/6M/1Y)
  - All charts use **Recharts** library. Interactive hover states.

- **Focus page** (`src/pages/Focus.jsx`): Build in `src/components/focus/`:
  - `FocusTimer.jsx` — Select task, countdown timer (45:00), Pause/Resume/Finish controls
  - `FocusStats.jsx` — Focus time today/week/month

- **Challenges page** (`src/pages/Challenges.jsx`): Build in `src/components/challenges/`:
  - `ChallengeCard.jsx` — Active challenge with progress bar, days remaining
  - `ChallengeTemplates.jsx` — 7 templates (30 Day Discipline, Reading, Workout, Study Streak, No Zero Days, Early Morning, Digital Detox)
  - `ChallengeModal.jsx` — Create custom challenge (name, duration, daily requirement, start date, reminder)

- **Goals**: Build in `src/components/goals/`:
  - `GoalCard.jsx` — Goal with target date, linked tasks, progress bar
  - `GoalModal.jsx` — Create/edit goal (name, description, target date, link tasks)
  - Goals section can be on Dashboard or a dedicated area

- **History page** (`src/pages/History.jsx`): Build in `src/components/history/`:
  - `ActivityTimeline.jsx` — Chronological event list (completions, misses, focus, challenges)
  - `HistoryFilters.jsx` — Filter by All/Completed/Missed/Rescheduled/Focus/Challenges

- **Weekly Planning**: 7-day view with task assignment to days, planned/completed/missed status

- **Settings page** (`src/pages/Settings.jsx`): Theme (Dark/Light/System), week start day, reminder defaults, streak/recovery settings, data export/import/clear, about section

- **Onboarding**: Build in `src/components/onboarding/`:
  - `OnboardingModal.jsx` / `OnboardingStep.jsx` — 6-screen flow:
    1. Welcome: "LockedIN" + "Build consistency. One commitment at a time." + Get Started button
    2. Interest selection: Study/Fitness/Health/Career/Learning/Personal/Other (multi-select)
    3. Main goal: text input
    4. Commitment level: 1-3 / 4-6 / 7+ commitments
    5. First commitment: task name, frequency, reminder, priority
    6. Summary: "You're LockedIN." + Enter Dashboard button
  - Save onboarding completion in localStorage via storageService

- **Search**: `src/components/search/GlobalSearchModal.jsx` — Cmd+K search across tasks/goals/challenges/history

- **Quick Add**: Floating + button on major screens with options for Task/Goal/Challenge/Focus session/Reflection

- **Achievements**: Unlockable badges (First Commitment, 7/30 Day Streak, 100/250 Tasks, No Zero Day, Comeback, Challenge Complete, 100 Focus Hours)

- **Notification UI**: `src/components/notifications/NotificationDrawer.jsx` — Reminder time/behavior configuration (frontend only)

### M6: Testing & Polish
- All features working end-to-end
- localStorage persistence verified (survives refresh)
- Responsive at 1440px / 768px / 390px
- Dark and light modes both fully styled
- Empty states for all sections
- No console errors
- No broken UI on edge cases
- Every button functional
- `npm run build` passes cleanly

## Design System (in tailwind.config.js)
- **Dark** (default): `#09090B` bg, `#18181B` surface, `#27272A` border, `#F4F4F5` text, `#A1A1AA` secondary
- **Light**: `#FAFAFA` bg, `#FFFFFF` surface, `#E4E4E7` border, `#18181B` text
- **Accent**: Crimson `#E11D48` primary, `#BE123C` hover, `#991B1B` active — used strategically
- **Status**: Success `#10B981`, Warning `#F59E0B`, Danger `#EF4444`
- **Font**: Inter. **Shadows**: subtle, elevated, crimson-subtle. **Animations**: fade-in, scale-in, pulse-subtle

## Brand
- **LockedIN** (exact caps). Tagline: "Plan less. Do more. Stay consistent." (sparingly)
- Feel: Premium, minimal, calm, focused. NOT: basic todo, children's tracker, gaming app

## Key Rules
1. No component > 300 lines
2. All localStorage through storageService.js only
3. Use existing UI primitives (Button, Modal, Card, etc.) — don't reimplement inline
4. Realistic mock data ("Study Pharmacology", "Workout", "Read 20 pages")
5. All data from storageService methods — components call service, not localStorage

Working directory: `c:\Users\Windows-10\Desktop\Antigravity projects\locked IN`
Integrity mode: development

## Acceptance Criteria

### Build and Runtime
- [ ] `npm run build` produces production build without errors
- [ ] Zero console errors navigating all pages

### Feature Completeness
- [ ] All 8 sidebar nav items route to fully functional pages
- [ ] Onboarding: 6 screens, saves state, skips on return
- [ ] Task CRUD: create/edit/complete/undo/pause/delete
- [ ] Dashboard: progress %, quick stats, priority-grouped tasks, reminders, at-risk, No Zero Day
- [ ] Calendar: monthly view with consistency indicators, date details, month navigation
- [ ] Graphs: 6 chart types with data, timeframe selector, hover states
- [ ] Challenges: start template, create custom, track progress
- [ ] Focus: timer with pause/resume/finish, session recorded, stats
- [ ] Goals: create, link tasks, view progress
- [ ] Weekly Planning: 7-day view
- [ ] Reflection: mood + text, saved
- [ ] History: timeline with filtering
- [ ] Streaks: calculated correctly
- [ ] Recovery Pass: works with limited supply
- [ ] Missed Task Recovery: all 5 options
- [ ] Consistency Score: 0-100 with breakdown
- [ ] Achievements: 5+ unlock on activity
- [ ] Global Search: across all entities
- [ ] Quick Add: floating button
- [ ] Settings: theme persists, export/import/clear

### UI/UX
- [ ] Dark default, light consistent
- [ ] Inter font, crimson accent strategic
- [ ] Animations + prefers-reduced-motion
- [ ] Empty states everywhere

### Data Persistence
- [ ] All data survives refresh
- [ ] No direct localStorage outside storageService

### Responsive
- [ ] 1440px sidebar + multi-column
- [ ] 768px collapsed/mobile nav
- [ ] 390px bottom nav, single column

### Code Quality
- [ ] R3 file structure
- [ ] No component > 300 LOC
- [ ] Reusable UI components used consistently

## 2026-09-27T18:45:32Z

**FINAL MILESTONE** — Complete Milestone 6 (Testing & Polish) for **LockedIN**. Milestones 1–5 are fully implemented and the production build passes (2470 modules, 25.7s, zero errors).

## Current State

93 source files exist across the full R3 directory structure. `npm run build` passes cleanly. The app has:
- Full storage service abstraction (storageService.js + 6 domain modules)
- 90-day realistic mock data
- 8 UI primitives (Button, Modal, Card, Badge, ProgressBar, Tabs, EmptyState, Tooltip)
- Layout (Sidebar 256px, MobileNavigation, TopBar)
- HashRouter with 8 page routes
- Dashboard (ProgressCard, QuickStats, TodayTasks, UpcomingReminders, AtRiskTasks, NoZeroDayCard)
- Tasks (TaskList, TaskCard, TaskFilters, AddTaskModal, EditTaskModal, MissedTaskRecoveryModal)
- Calendar (CalendarGrid, DayDetails)
- ReflectionModal
- 6 Recharts charts (ConsistencyChart, CompletedMissedChart, CategoryChart, ActivityHeatmap, StreakChart) + GraphFilters
- FocusTimer + FocusStats
- ChallengeCard, ChallengeTemplates, ChallengeModal
- GoalCard, GoalModal
- ActivityTimeline, HistoryFilters, WeeklyPlanner
- Settings page with theme toggle and data export/import/clear
- 6-screen OnboardingModal
- GlobalSearchModal (Cmd+K)
- QuickAddFab + QuickAddModal
- NotificationDrawer

## Milestone 6 Requirements

This is the final polish and verification milestone. Your job is to:

### 1. Fix Any Runtime Errors
- Run `npm run dev` and navigate through ALL 8 pages
- Fix any console errors, import errors, or crashes
- Ensure every page renders without errors
- Test all interactive features (task CRUD, completion toggle, focus timer, etc.)

### 2. Verify & Fix Feature Completeness
- **Onboarding**: 6 screens work, saves state, skips on return visit
- **Dashboard**: All 6 cards render with data, task completion works with visual feedback
- **Tasks**: Create/edit/complete/undo/pause/delete all work. Search, filter, sort work.
- **Calendar**: Monthly grid shows consistency indicators, clicking date shows details, month nav works
- **Graphs**: All 6 charts render with mock data, timeframe selector changes data, hover tooltips work
- **Challenges**: Can start template and create custom, progress tracked
- **Focus**: Timer starts/pauses/resumes/finishes, session saved, stats show
- **Goals**: Create goal, link tasks, view progress
- **History**: Timeline shows events, filters work
- **Settings**: Theme toggle (Dark/Light/System) persists, export/import/clear work
- **Search**: Cmd+K opens search, returns results
- **Quick Add**: FAB on main screens, opens creation options
- **Streaks & Recovery**: Displayed correctly, recovery pass works
- **Consistency Score**: Shows 0-100 with breakdown
- **Achievements**: At least 5 unlock based on activity
- Fix any non-functional buttons or placeholder content

### 3. localStorage Persistence
- Verify data survives browser refresh
- Verify NO direct localStorage calls outside storageService.js
- Run: `Get-ChildItem -Path src/components,src/pages -Recurse -Filter *.jsx | Select-String 'localStorage'` — must return 0 results

### 4. Responsive Design Polish
- **1440px**: Sidebar visible, multi-column dashboard
- **768px**: Sidebar collapses or becomes mobile nav
- **390px**: Bottom nav, single-column, mobile-friendly modals
- No horizontal overflow at any breakpoint
- Fix any broken layouts

### 5. Theme Polish
- Dark mode is default and fully styled
- Light mode is visually consistent (no unstyled elements)
- Theme toggle works and persists across refresh

### 6. Empty States
- Every section with potentially no data shows a useful empty state with CTA
- Test by clearing localStorage and checking each page

### 7. Animations & Accessibility
- Animations on checkbox completion, modal open/close, progress updates
- Respect `prefers-reduced-motion`
- Keyboard navigation works for major interactions
- ARIA labels on buttons and interactive elements
- Visible focus states

### 8. Code Quality Final Check
- No component > 300 LOC
- Reusable UI components used consistently
- No inline re-implementations of Button, Modal, Card, etc.
- Realistic mock data throughout (no lorem ipsum)

### 9. Final Build Verification
- `npm run build` passes with zero errors
- `npm run dev` starts cleanly

## Working directory
`c:\Users\Windows-10\Desktop\Antigravity projects\locked IN`

Integrity mode: development

## Design System Reference
- **Dark**: `#09090B` bg, `#18181B` surface, `#27272A` border, `#F4F4F5` text
- **Light**: `#FAFAFA` bg, `#FFFFFF` surface, `#E4E4E7` border, `#18181B` text
- **Accent**: Crimson `#E11D48` (strategic use only)
- **Font**: Inter

## Acceptance Criteria
- [ ] `npm run build` passes
- [ ] Zero console errors navigating all 8 pages
- [ ] All interactive features work (task CRUD, focus timer, challenge start, goal creation, reflection, search, quick add)
- [ ] localStorage persistence survives refresh
- [ ] Dark and light modes both fully styled
- [ ] Responsive at 1440/768/390px
- [ ] Empty states present in all sections
- [ ] No placeholder pages or non-functional buttons
- [ ] No component > 300 LOC
- [ ] No direct localStorage calls outside storageService.js

## 2026-09-28T15:36:31Z

**FINAL POLISH** — Complete the remaining Milestone 6 remediation for **LockedIN**. The build passes cleanly (2473 modules, 0 errors).

## What's Already Done
All M1–M5 features are implemented. Two M6 remediation items are already complete:
- ✅ `WeeklyPerformanceChart.jsx` (6th Recharts chart)
- ✅ `AchievementsModal.jsx` (unlock tracking, progress bars, celebration effects)

## Remaining Remediation Items (7 of 9)

Complete these remaining polish items:

### 1. Tailwind Light Theme Styling & UI Primitive Polish
- Ensure ALL components render correctly in light mode (no unstyled or broken elements)
- Verify dark mode remains the default and looks premium
- Check all UI primitives (Button, Modal, Card, Badge, ProgressBar, Tabs, EmptyState, Tooltip) in both themes

### 2. Consistency Score Interactive Breakdown Modal
- The dashboard shows a consistency score (0-100)
- Add an interactive modal that breaks down the score components (completion rate, no-zero-days rate, streak health, resilience)
- Users should be able to click the score to see the breakdown

### 3. Tasks "Today" Tab Filter Correction
- Ensure the "Today" filter in the Tasks page correctly shows only today's tasks
- Verify all other filters work: All, Daily, Weekly, Monthly, Completed, Missed

### 4. Empty State vs Auto-Reseed Separation
- When localStorage is empty, show proper empty states with CTAs (not auto-loaded mock data)
- Mock data should only be loaded during onboarding or via a "Load Sample Data" option in Settings
- Every major section needs a useful empty state: Tasks, Calendar, Challenges, Goals, History, Graphs

### 5. History Filters Granularity
- Ensure all filter options work: All, Completed, Missed, Rescheduled, Focus, Challenges
- Verify the timeline renders events chronologically

### 6. QuickAdd Modal Options Expansion
- The floating + button should offer: Task, Goal, Challenge, Focus session, Reflection
- Each option should open the appropriate creation modal

### 7. Accessibility Focus Rings & WeeklyPlanner LOC Decomposition
- Add visible focus rings to all interactive elements
- Ensure keyboard navigation works for major flows (tab through tasks, enter to complete)
- If WeeklyPlanner.jsx exceeds 300 LOC, decompose it into smaller sub-components
- ARIA labels on buttons and interactive elements
- Respect `prefers-reduced-motion`

## Additional Final Checks

After completing the 7 items above:

1. **Run `npm run build`** — must pass with 0 errors
2. **Verify localStorage persistence** — create a task, refresh browser, task must still be there
3. **Verify no direct localStorage calls in components**:
   ```powershell
   Get-ChildItem -Path src/components,src/pages -Recurse -Filter *.jsx | Select-String 'localStorage'
   ```
   Must return 0 results.
4. **Check responsive layouts**:
   - 1440px: sidebar + multi-column dashboard
   - 768px: sidebar collapses
   - 390px: bottom nav, single column
5. **Verify all 8 sidebar navigation items** route to functional pages (no placeholders)
6. **No non-functional buttons** anywhere in the app

## Design System
- **Dark**: `#09090B` bg, `#18181B` surface, `#27272A` border, `#F4F4F5` text
- **Light**: `#FAFAFA` bg, `#FFFFFF` surface, `#E4E4E7` border, `#18181B` text  
- **Accent**: Crimson `#E11D48` (strategic use)
- **Font**: Inter

## Key Rules
- No component > 300 LOC
- All localStorage through storageService.js only
- Use existing UI primitives consistently
- Realistic mock data (no lorem ipsum)

Working directory: `c:\Users\Windows-10\Desktop\Antigravity projects\locked IN`
Integrity mode: development

## Acceptance Criteria
- [ ] `npm run build` passes with 0 errors
- [ ] All 7 remediation items completed
- [ ] Light mode fully styled across all pages
- [ ] Consistency score modal shows breakdown
- [ ] Tasks "Today" filter works correctly
- [ ] Empty states shown when no data (not auto-loaded mock data)
- [ ] History filters all functional
- [ ] QuickAdd offers all 5 options
- [ ] Focus rings and keyboard navigation work
- [ ] No component > 300 LOC
- [ ] No direct localStorage calls outside storageService.js
- [ ] Responsive at 1440/768/390px
- [ ] Zero console errors across all pages

## 2026-09-29T11:55:00Z

**FINAL FIXES** for LockedIN. The build passes (2473 modules, 0 errors). 96 source files, all under 300 LOC, zero localStorage calls in components. Almost everything is done. Complete these remaining items:

## Remaining Items

### 1. QuickAdd: Add Goal and Challenge options
Currently `src/components/quickadd/QuickAddModal.jsx` only has 3 tabs: Task, Focus, Reflection. It needs 5 options: **Task, Goal, Challenge, Focus session, Reflection**. Add Goal and Challenge tabs/forms. These can be simple forms that call `storageService.createGoal()` and `storageService.createChallenge()` respectively.

### 2. Empty State vs Mock Data Separation
Verify that when localStorage is completely empty (fresh user), the app shows proper empty states with calls-to-action rather than auto-loading mock data. The onboarding flow should appear for new users. Mock/sample data should only be loadable via Settings ("Load Sample Data" button). Check `src/data/mockData.js` and how it's initialized.

### 3. Light Mode Final Check
Ensure light mode looks polished across all pages. The M6 worker updated many components — verify the light mode styling is consistent and no elements are unstyled or invisible in light mode.

### 4. Final Build & Verification
- Run `npm run build` — must pass
- Verify no console errors would appear when navigating all 8 pages
- Ensure all 8 sidebar routes work
- Verify onboarding appears for new users

## Working Directory
`c:\Users\Windows-10\Desktop\Antigravity projects\locked IN`

Integrity mode: development

## Key Architecture Rules
- No component > 300 LOC
- All localStorage through storageService.js only
- Use existing UI primitives (Button, Modal, Card, etc.)

## Acceptance Criteria
- [ ] QuickAdd has 5 options: Task, Goal, Challenge, Focus, Reflection
- [ ] Empty states shown for new users (no auto-loaded mock data)
- [ ] Onboarding appears on first visit
- [ ] Light mode is consistent across all pages
- [ ] `npm run build` passes
- [ ] No component > 300 LOC
- [ ] No direct localStorage outside storageService.js


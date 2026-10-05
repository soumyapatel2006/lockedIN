# Project: LockedIN

## Architecture
- **Tech Stack**: React 18.3.1, Vite 5.4, Tailwind CSS 3.4, Lucide React, Recharts 2.13, Canvas Confetti, clsx + tailwind-merge.
- **Persistence Architecture**: Pure frontend localStorage via strict abstraction layer `src/services/storageService.js`.
  - Zero direct `localStorage` calls anywhere outside `src/services/storageService.js`.
  - Robust schema validation, defensive fallbacks, and ~90 days realistic seed data.
- **Component Hierarchy & Size Boundaries**:
  - All components strictly < 300 lines of code.
  - Complex screens split into lean containers + dedicated sub-components + utility calculations.
- **Design System**:
  - Dark mode default (`zinc-950` canvas `#09090B`, `zinc-900` card `#18181B`, `zinc-800` border `#27272A`).
  - Light mode support (`zinc-50` canvas `#FAFAFA`, white cards `#FFFFFF`).
  - Deep Crimson accent (`#E11D48` primary, `#BE123C` hover, `#991B1B` active).
  - Inter typography scale and smooth micro-animations.
- **Responsiveness**:
  - Desktop (>= 1024px / 1440px): 256px pinned sidebar, multi-column dashboard.
  - Tablet (768px): 64px icon sidebar / drawer navigation.
  - Mobile (390px): Bottom navigation bar (`MobileNavigation.jsx`), single-column cards, bottom sheet dialogs.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Node/Vite/Tailwind Tooling | Build pipeline, configs, dependencies, package.json, index.html | M1 | survey_env |
| 2 | Styling & Theme System | Dark mode default, light mode toggle, deep crimson palette, Inter font | M1 | survey_ui |
| 3 | Storage Service Architecture | Abstraction layer for all CRUD, search, calculations, and persistence | M2 | survey_spec |
| 4 | Task & Habit Data Models | JSDoc/schemas for tasks, completions, frequency, priority, reminders | M2 | survey_spec |
| 5 | Goal & Challenge Models | Schemas for goals, linked commitments, and 7 challenge templates | M2 | survey_spec |
| 6 | Focus & Reflection Models | Schemas for focus timer sessions, moods, and daily reflections | M2 | survey_spec |
| 7 | Multi-tier Streak Calculation | Current, longest, weekly, monthly streaks with Recovery Pass logic | M2 | survey_spec |
| 8 | Consistency Score Formula | 0–100 composite score (40% completion, 30% no-zero, 20% streak, 10% resilience) | M2 | survey_spec |
| 9 | Missed Task Recovery Logic | 5 recovery options (do today, reschedule, drop without guilt, substitute, micro-version) | M2 | survey_spec |
| 10 | 90-day Mock Data Engine | Realistic 90-day history (~84% consistency, 10 authentic tasks, focus logs) | M2 | survey_spec |
| 11 | UI Component Primitives | Button, Modal, Card, Badge, ProgressBar, Tabs, EmptyState, Tooltip (<300 LOC each) | M3 | survey_ui |
| 12 | Sidebar Navigation | Desktop 256px pinned navigation with active indicator and badge counts | M3 | survey_ui |
| 13 | Mobile Bottom Navigation | Mobile 5-tab bar with touch-friendly targets and safe-area padding | M3 | survey_ui |
| 14 | TopBar & Global Controls | Header with date, theme toggle, quick add trigger, search trigger, notifications | M3 | survey_ui |
| 15 | Routing & Page Shell | Seamless navigation across 8 pages and global modal overlays | M3 | survey_ui |
| 16 | ProgressCard Component | Today's completion percentage ring, tasks done/total, live status | M4 | survey_ui |
| 17 | QuickStats Component | 4-card grid: Consistency Score, Current Streak, Total Completions, Focus Hours | M4 | survey_ui |
| 18 | TodayTasks Component | Grouped by priority tiers (Must Do, Should Do, Nice to Have) with toggle & recovery | M4 | survey_ui |
| 19 | UpcomingReminders Component | Tasks with reminder times for today and upcoming alerts | M4 | survey_ui |
| 20 | AtRiskTasks Component | Tasks not completed in 2+ days or approaching deadline with action triggers | M4 | survey_ui |
| 21 | NoZeroDayCard Component | Encouragement message when >=1 task completed, or easiest task nudge when 0 | M4 | survey_ui |
| 22 | Tasks Page & TaskList | Task view with search, filter tabs, sorting, empty states, and pagination | M4 | survey_ui |
| 23 | TaskCard Component | Rich card with area badge, priority, streak, frequency, action menu (edit, pause, delete) | M4 | survey_ui |
| 24 | AddTaskModal Component | Modal form with title, area, priority, frequency, reminder, linked goal | M4 | survey_ui |
| 25 | EditTaskModal Component | Full task edit modal with pause option and streak retention | M4 | survey_ui |
| 26 | MissedTaskRecoveryModal | Interactive modal providing the 5 distinct recovery options with guided actions | M4 | survey_ui |
| 27 | Calendar View & Grid | Month calendar with day cells showing consistency intensity dots | M4 | survey_ui |
| 28 | DayDetails Drawer/Panel | Detailed panel showing completed/missed tasks, focus minutes, and reflection for date | M4 | survey_ui |
| 29 | Daily Reflection Modal | 4-state mood selector, prompt: what went well, prompt: what to improve | M4 | survey_ui |
| 30 | ConsistencyChart (Recharts) | 30-day / 90-day consistency score line/area trend chart | M5 | survey_ui |
| 31 | CompletedMissedChart (Recharts) | Stacked bar chart showing completed vs missed tasks over time | M5 | survey_ui |
| 32 | CategoryChart (Recharts) | Radar / Polar / Donut breakdown of activity across 7 Areas of Life | M5 | survey_ui |
| 33 | ActivityHeatmap (Recharts/SVG) | GitHub-style 90-day intensity heatmap with tooltips | M5 | survey_ui |
| 34 | StreakChart (Recharts) | Visual timeline of streak milestones, active streaks, and recovery pass uses | M5 | survey_ui |
| 35 | GraphFilters Component | Timeframe selector (7D, 30D, 90D, Year, All) and category filters | M5 | survey_ui |
| 36 | FocusTimer Component | Pomodoro / Deep work timer (25/50/custom min) with play/pause/reset and chime | M5 | survey_ui |
| 37 | FocusStats Component | Total focus hours, today's sessions, streak, linked task logs | M5 | survey_ui |
| 38 | ChallengeCard Component | Active challenge card with progress bar, days remaining, rules | M5 | survey_ui |
| 39 | ChallengeTemplates Component | 7 pre-built templates (75 Hard, 30-Day Morning, Dopamine Detox, Deep Work, etc.) | M5 | survey_ui |
| 40 | ChallengeModal Component | Create custom challenge with target habits, duration, and commit rules | M5 | survey_ui |
| 41 | GoalCard Component | Goal card with target date, linked commitments count, and progress bar | M5 | survey_ui |
| 42 | GoalModal Component | Create/edit goal with category, milestone dates, and linked habit selection | M5 | survey_ui |
| 43 | Weekly Planning View | 7-day visual planner to assign target tasks to specific weekdays and review week | M5 | survey_ui |
| 44 | ActivityTimeline Component | Chronological audit trail of completions, focus sessions, streaks, and reflections | M5 | survey_ui |
| 45 | HistoryFilters Component | Date range filter, event type filter (tasks, focus, reflection, challenge) | M5 | survey_ui |
| 46 | Achievements Badges System | Unlockable badges with icons, progress, unlocked date, and celebration animation | M5 | survey_ui |
| 47 | Areas of Life Management | 7 core categories (Health, Career, Mindset, Relationships, Finance, Fitness, Creativity) | M5 | survey_ui |
| 48 | Quick Add Floating Button (FAB) | Floating quick-add button opening speed modal for task, reflection, or focus | M5 | survey_ui |
| 49 | Global Search Modal | Cmd+K / search button opening quick search across tasks, goals, challenges, history | M5 | survey_ui |
| 50 | Notification UI Drawer | In-app notification bell showing upcoming reminders, at-risk alerts, streak warnings | M5 | survey_ui |
| 51 | Settings Page | Theme selector (Dark/Light/System), sound toggles, daily reminder time | M5 | survey_ui |
| 52 | Data Export / Import / Clear | JSON export backup, full JSON restore with validation, factory reset with confirmation | M5 | survey_ui |
| 53 | Onboarding 6-Screen Flow | Welcome → Identity/Goals → Habit Selection → Schedule Setup → Recovery Intro → Ready | M5 | survey_ui |
| 54 | Empty States & Micro-interactions | Polished empty states with call-to-action buttons for all lists and tabs | M5 | survey_ui |
| 55 | E2E Test Suite (Tiers 1-4) | Requirement-driven test harness and test cases covering all 60 features | M6 | survey_spec |
| 56 | Adversarial Hardening (Tier 5) | Stress tests, boundary tests, edge cases, quota overflow, corrupt JSON recovery | M6 | survey_spec |
| 57 | Build & Asset Verification | npm run build passes with 0 errors, chunks optimized, assets verified | M6 | survey_env |
| 58 | Responsive Polish (1440/768/390) | Verified pixel-perfect layout at 1440px desktop, 768px tablet, 390px mobile | M6 | survey_ui |
| 59 | Code Quality & LOC Compliance | Every file strictly < 300 LOC, zero direct localStorage calls | M6 | survey_spec |
| 60 | Forensic Integrity Verification | Full audit verifying genuine implementation, zero cheating, zero dummy facades | M6 | survey_spec |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Environment & Build Tooling | Node provisioning, package.json, configs (vite, tailwind, postcss), index.html, build pipeline | none | PLANNED |
| M2 | Storage Service & Mock Data Engine | storageService.js (all 40+ methods), mockData.js (90 days), calculations.js, dateUtils.js | M1 | PLANNED |
| M3 | UI Primitives & Responsive Layout | src/components/ui/ (8 primitives), layout/ (Sidebar, MobileNav, TopBar), theme engine, routing shell | M1, M2 | PLANNED |
| M4 | Core Productivity Modules | Dashboard (5 cards), Tasks (CRUD + 5-option Recovery), Calendar + DayDetails, Reflection modal | M2, M3 | PLANNED |
| M5 | Advanced Engagement Modules | Graphs (6 Recharts charts), Focus timer, Challenges, Goals, Weekly Planning, History, Settings, Onboarding, Search, Notifications | M2, M3, M4 | PLANNED |
| M6 | E2E Testing, Adversarial Hardening & Audit | Opaque-box E2E test suite (Tiers 1-4), adversarial test hardening (Tier 5), build & responsiveness verification, forensic audit | M1-M5 | PLANNED |

## Interface Contracts

### `src/services/storageService.js` Contract
- **Task Management**:
  - `getTasks(filter)`: `Task[]`
  - `getTaskById(id)`: `Task | null`
  - `createTask(taskData)`: `Task`
  - `updateTask(id, updates)`: `Task`
  - `deleteTask(id)`: `boolean`
  - `pauseTask(id, isPaused)`: `Task`
  - `toggleTaskCompletion(id, dateStr)`: `{ task: Task, completed: boolean, streak: StreakData }`
  - `recoverMissedTask(id, dateStr, recoveryAction, payload)`: `{ task: Task, recoveryResult: object }`
- **Completions & Activity**:
  - `getCompletions(startDate, endDate)`: `Completion[]`
  - `getCompletionsForDate(dateStr)`: `Completion[]`
  - `getNoZeroDayStatus(dateStr)`: `{ isNoZeroDay: boolean, count: number, easiestTaskId: string }`
- **Consistency & Streaks**:
  - `calculateConsistencyScore(timeframeDays)`: `ConsistencyScore { score: number, completionRate: number, noZeroDaysRate: number, streakHealth: number, resilience: number }`
  - `getStreakData(taskId)`: `StreakData { current: number, longest: number, weeklyStreak: number, monthlyStreak: number, recoveryPassesAvailable: number, recoveryPassesUsed: number }`
  - `useRecoveryPass(taskId, dateStr)`: `{ success: boolean, remainingPasses: number }`
- **Goals & Challenges**:
  - `getGoals()`: `Goal[]`
  - `createGoal(goalData)`: `Goal`
  - `updateGoal(id, updates)`: `Goal`
  - `deleteGoal(id)`: `boolean`
  - `getChallenges()`: `Challenge[]`
  - `createChallenge(challengeData)`: `Challenge`
  - `updateChallenge(id, updates)`: `Challenge`
  - `deleteChallenge(id)`: `boolean`
- **Focus & Reflection**:
  - `getFocusSessions(startDate, endDate)`: `FocusSession[]`
  - `saveFocusSession(sessionData)`: `FocusSession`
  - `getFocusStats()`: `{ totalMinutes: number, sessionsCount: number, currentStreak: number }`
  - `getReflections(startDate, endDate)`: `Reflection[]`
  - `saveReflection(dateStr, reflectionData)`: `Reflection`
- **Settings, Search, Import/Export**:
  - `getSettings()`: `Settings`
  - `updateSettings(updates)`: `Settings`
  - `exportDataJSON()`: `string`
  - `importDataJSON(jsonStr)`: `{ success: boolean, error?: string }`
  - `resetToMockData()`: `void`
  - `clearAllData()`: `void`
  - `globalSearch(query)`: `{ tasks: Task[], goals: Goal[], challenges: Challenge[], history: ActivityEvent[] }`

## Code Layout
```
src/
  components/
    layout/
      Sidebar.jsx
      MobileNavigation.jsx
      TopBar.jsx
    dashboard/
      ProgressCard.jsx
      QuickStats.jsx
      TodayTasks.jsx
      UpcomingReminders.jsx
      AtRiskTasks.jsx
      NoZeroDayCard.jsx
    tasks/
      TaskCard.jsx
      TaskList.jsx
      TaskFilters.jsx
      AddTaskModal.jsx
      EditTaskModal.jsx
      MissedTaskRecoveryModal.jsx
    calendar/
      Calendar.jsx
      CalendarGrid.jsx
      DayDetails.jsx
    graphs/
      ConsistencyChart.jsx
      CompletedMissedChart.jsx
      CategoryChart.jsx
      ActivityHeatmap.jsx
      StreakChart.jsx
      GraphFilters.jsx
    challenges/
      ChallengeCard.jsx
      ChallengeTemplates.jsx
      ChallengeModal.jsx
    focus/
      FocusTimer.jsx
      FocusStats.jsx
    goals/
      GoalCard.jsx
      GoalModal.jsx
    history/
      ActivityTimeline.jsx
      HistoryFilters.jsx
    reflection/
      ReflectionModal.jsx
    onboarding/
      OnboardingModal.jsx
      OnboardingStep.jsx
    search/
      GlobalSearchModal.jsx
    notifications/
      NotificationDrawer.jsx
    ui/
      Button.jsx
      Modal.jsx
      Card.jsx
      Badge.jsx
      ProgressBar.jsx
      Tabs.jsx
      EmptyState.jsx
      Tooltip.jsx
  pages/
    Dashboard.jsx
    Tasks.jsx
    Calendar.jsx
    Graphs.jsx
    Challenges.jsx
    Focus.jsx
    History.jsx
    Settings.jsx
  data/
    mockData.js
  utils/
    calculations.js
    dateUtils.js
    cn.js
  services/
    storageService.js
  App.jsx
  main.jsx
  index.css
```

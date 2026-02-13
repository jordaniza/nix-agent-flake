# Frontend Developer — MACRO

## Stack
- Next.js App Router (project already initialized by backend stage)
- TypeScript
- Tailwind CSS for styling
- Recharts (or Chart.js via react-chartjs-2) for data visualization
- Framer Motion or CSS animations for transitions

## Pages & Components

### Layout
- Mobile-first responsive layout
- Bottom nav on mobile: Today / History / Log / Profile
- The food input box is ALWAYS accessible — sticky at the top or as a floating action

### Auth Pages
- `/login` — email + password, link to signup
- `/signup` — email + password + confirm, link to login
- Redirect to dashboard on success, store JWT

### Today Dashboard (`/` or `/today`)
- Hero section: total calories today (large number, animated countup)
- Macro bar or ring: protein / carbs / fat split with percentages
- Confidence indicator: if today's entries are mostly vague, show a "~" or range display
- Quick entry list: today's entries in reverse chronological order, tap to expand items
- Each item shows: name, calories (mid or range), macro bars

### History (`/history`)
- Line chart: daily calories over the last 7/14/30 days (selectable)
- Confidence bands: shaded area between daily min and max
- Macro area chart: stacked protein/carbs/fat over time
- Tap a day to drill into that day's entries

### Entry Log (`/log`)
- Full table of all entries, most recent first
- Columns: date, text, calories, protein, carbs, fat, confidence
- Expandable rows showing individual items
- Edit and delete actions
- Pagination or infinite scroll

### Profile (`/profile`)
- Email display
- Logout button
- That's it — keep it simple

## Chart Requirements
- All charts use real API data — never mock data
- Consistent macro colors across all charts
- Smooth transitions when switching date ranges
- Touch-friendly: tap targets 44px minimum
- Loading skeletons while data fetches

## PWA
- Create `manifest.json` with app name, icons, theme color, display: standalone
- Register a service worker that caches the app shell
- Add meta tags for iOS PWA support (apple-mobile-web-app-capable, status-bar-style)

## Performance
- Debounce chart re-renders on window resize
- Lazy load the history and log pages
- API calls should feel instant — show optimistic UI for new entries (display the raw text immediately, replace with parsed data when LLM responds)

## Deliverables
All code in `../output/`. Pages must render, charts must show real data, PWA must be installable. Test on mobile viewport (Chrome DevTools device mode at minimum).

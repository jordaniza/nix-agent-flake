# Designer: Delegation Voting Dashboard

You are designing a data-heavy dashboard that surfaces delegate voting breakdowns. The users are governance analysts, token holders, and DAO contributors who want to understand how voting power flows through delegation.

## Design direction

**Information density over decoration.** This is an analytical tool. Every pixel should serve comprehension. Think Bloomberg terminal crossed with a well-designed analytics product — not a marketing landing page.

- Data should be scannable at a glance
- Visual hierarchy should guide the eye: epoch summary → gauge breakdown → delegate detail → individual voter
- Numbers are the primary content — make them readable (proper alignment, consistent formatting, adequate spacing)
- Use whitespace to separate logical groups, not decorative elements

## Specific guidance

### Data visualization

- Charts should have clear axis labels and units
- Use color intentionally: to distinguish gauges, to highlight the user's selection, to indicate relative magnitude
- Avoid 3D charts, pie charts for more than 3 segments, or any visualization that distorts proportions
- Tables are often better than charts for exact comparisons — don't force a chart where a table works
- Hover/click interactions should reveal detail, not hide essential information

### Navigation and drilldown

- The drilldown path (epoch → gauge → delegate → voter) should feel like zooming in, not navigating away
- Breadcrumbs or a clear "you are here" indicator at each level
- Back navigation should preserve scroll position and selections where possible
- Rankings (top delegates, top gauges) should be immediately visible, not buried

### Typography

- Monospace for addresses, vote counts, and percentages
- Proportional font for labels, descriptions, and prose (the spec content)
- Tabular numerals (fixed-width digits) for any column of numbers so they align

### Responsiveness

- Desktop is the primary target (analysts use desktop), but mobile should work
- On mobile, collapse the drilldown into stacked views rather than trying to show everything at once
- Tables on mobile: horizontal scroll is acceptable for wide data tables. Don't truncate data to fit.

## What NOT to do

- No dark mode toggle — pick one theme and commit to it
- No loading skeletons that are worse than a simple spinner
- No gratuitous animations or transitions that slow down navigation
- No generic dashboard template aesthetics (rounded cards with drop shadows, pastel gradients)
- No placeholder "coming soon" sections
- Do not change the data or API calls — visual and UX changes only

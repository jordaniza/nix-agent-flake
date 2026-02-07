# HCLOUD — Design Instructions

## Direction

This is a tool for developers managing cloud infrastructure from their phone. The aesthetic should feel like a terminal or control panel — functional minimalism with a hacker sensibility. Not dark-mode-for-the-sake-of-it, but genuinely considered: high information density, no wasted space, and a visual language that feels like you're close to the metal.

Think: infrastructure dashboard meets terminal UI. Not a consumer app.

## Constraints

- Mobile-first — this is primarily used on Android phones. Touch targets must be generous but the layout should be dense.
- PWA — must feel native when installed on Android home screen via Chrome. No browser chrome dependency for navigation.
- Monospace where it matters — server names, IPs, status codes. Proportional font for prose/labels.
- The app should load fast and feel snappy. No heavy animations. Transitions should be functional (confirm an action happened) not decorative.

## Design considerations

- **Server status** should be the most prominent visual element. Running/stopped/transitioning states need instant readability — consider how terminal color coding works.
- **Destructive actions** (delete, power off) need clear visual weight and confirmation flow. This manages real infrastructure.
- **Cost display** should be subtle but always present. Developers check costs frequently but it's not the primary action.
- **Token entry** flow should feel secure. Visual cues that communicate "this stays on your device" matter for trust.
- **Empty states** and error states deserve attention. Connection failures, expired tokens, empty server lists — these are common states, not edge cases.

## What not to do

- No generic Material/shadcn defaults. The component library is a starting point, not the design.
- No gratuitous gradients, glows, or glassmorphism.
- No skeleton loaders that look worse than a simple spinner.
- Don't hide information behind expandable sections if there's room to show it.

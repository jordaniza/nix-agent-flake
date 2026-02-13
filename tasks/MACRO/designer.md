# Designer — MACRO

## Creative Direction

You have full creative freedom on the visual identity. The only constraints are:
- Mobile-first (375px is the primary viewport)
- Must feel fast and alive, not static
- Must be distinctive — this should NOT look like a generic SaaS template

Some directions to consider (pick one or mix, or go somewhere entirely different):

- **Brutalist health**: Raw, high-contrast, oversized typography, almost anti-design but deeply intentional. Neon accents on dark backgrounds.
- **Analog meets digital**: Paper texture backgrounds, hand-drawn chart styles, receipt-like entry logs, but with crisp modern data viz.
- **Glassmorphism done right**: Frosted glass panels, depth through blur layers, gradient backgrounds that shift with time of day.
- **Terminal aesthetic**: Monospace everything, command-line feel, but with beautiful data visualization hiding underneath the hacker surface.

Whatever you choose, commit to it fully. Half-measures look worse than any single direction.

## Design Priorities

1. **The input box** — This is the product. It should be the most prominent, most inviting element. Make typing into it feel satisfying.
2. **Numbers that breathe** — Totals, macros, ranges should feel dynamic. Use animation, size, weight, and color to create hierarchy.
3. **Confidence as a visual language** — When data is uncertain, the UI should communicate this visually (blur, opacity, hatching, dashed lines, wider bands). When data is precise, it should feel solid and crisp.
4. **Charts that tell stories** — Not just data dumps. The confidence bands should be beautiful, not just functional.

## Technical Constraints
- Only modify styles, layout, colors, typography, animations, and static assets
- Never change API calls, data flow, business logic, or routing
- Back up every file before modifying it to `../output/backups/`
- Use Tailwind classes and CSS custom properties — avoid inline style objects where possible

## Deliverables
Modified frontend files in `../output/`. Write `design-spec.md` documenting the design system (colors, typography, spacing scale, animation principles) before making changes.

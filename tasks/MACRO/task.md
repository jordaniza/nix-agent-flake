# MACRO — Natural Language Food Tracker

## Overview

Build a mobile-first PWA where users type what they ate as free text (any level of detail) and get a dashboard showing calories, macronutrients, and trends over time. An LLM parses each entry into structured nutritional data. Less detail = wider confidence intervals shown in the UI.

## Core Concept

The user opens the app, types something like:

- "2 eggs, toast with butter, black coffee" → precise breakdown
- "big bowl of pasta" → estimated range (400-700 kcal, 50-90g carbs, etc.)
- "chicken stir fry with rice and vegetables, roughly a large plate" → moderate confidence
- "snacked on some nuts" → wide range

The LLM returns structured data with point estimates AND confidence ranges. The UI renders ranges as bands/intervals when uncertainty is high, and precise values when input is detailed.

## Key Requirements

### Input
- Single free-text box, always visible, submit on enter
- Each entry is timestamped and associated with the logged-in user
- Support quick re-logging (recent entries as suggestions)
- Entries can be edited or deleted

### LLM Integration
- Use Claude API (Anthropic key in .env) with **claude-haiku-4-5-20251001** — fast, cheap, good enough for food parsing
- Structured output: calories, protein, carbs, fat, fiber (each with min/mid/max)
- Single-shot prompt, no chat history needed — just the food description in, JSON out
- Keep the system prompt tight — no wasted tokens. Under 200 tokens for the system message
- Response should be JSON only, no preamble. Use stop sequences or prefill to enforce this
- Parse individual items from a single entry (e.g. "eggs and toast" → 2 line items)

### Data Model
- User: id, email, password_hash, created_at
- Entry: id, user_id, raw_text, timestamp, created_at
- EntryItem: id, entry_id, name, calories_min/mid/max, protein_min/mid/max, carbs_min/mid/max, fat_min/mid/max, fiber_min/mid/max, confidence (low/medium/high)

### Auth
- Simple email + password signup/login
- JWT stored in localStorage
- No OAuth, no magic links — keep it simple
- Protected API routes via middleware

### Dashboard
- **Today view** (default): total calories + macros for today, with stacked ranges if uncertain
- **History view**: daily totals over time as line/area charts with confidence bands
- **Entry log**: table of all entries with expandable item breakdown
- **Macro split**: donut/pie chart of protein/carbs/fat ratio
- **Weekly summary**: average daily intake, consistency score

### Visuals & Charts
- Use a proper charting library (Chart.js, Recharts, or similar via CDN)
- Confidence ranges rendered as shaded bands on line charts, error bars on bar charts
- Color-code macros consistently everywhere (protein=blue-ish, carbs=amber-ish, fat=red-ish — designer can refine)
- Animate chart transitions
- Numbers should feel alive — countup animations on totals

### Design
- Mobile-first, must feel native on phone
- PWA with manifest and service worker (installable, offline shell)
- Unique visual identity — not generic Bootstrap. Designer has creative freedom
- Dark mode preferred but designer decides
- The food input should feel effortless — the primary action

### Deployment
- Vercel deployment (frontend + serverless API routes)
- Supabase for Postgres database
- All env vars via Vercel environment config
- Must work on custom domain or .vercel.app URL

## Tech Stack

- **Frontend**: Next.js (App Router) with TypeScript
- **Backend**: Next.js API routes (serverless on Vercel)
- **Database**: Supabase (Postgres)
- **LLM**: Claude Haiku via Anthropic SDK
- **Charts**: Library of frontend dev's choice (Recharts recommended for React)
- **Auth**: Custom JWT (bcrypt + jsonwebtoken)
- **Hosting**: Vercel

## Done Criteria

1. User can sign up, log in, and stay logged in across sessions
2. Typing free text and submitting produces a structured nutritional breakdown within 2 seconds
3. Vague inputs show visible confidence ranges; precise inputs show tight values
4. Dashboard displays today's totals, macro breakdown chart, and entry log
5. History view shows daily trends over time with confidence bands
6. All charts render with real data, not mocks
7. PWA manifest present, app installable on mobile
8. Deployed to Vercel and accessible via URL
9. Mobile experience feels native — no horizontal scroll, touch-friendly targets, fast
10. Design is distinctive and polished — not a generic template

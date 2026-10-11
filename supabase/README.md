# Turning on the shared chase log (Supabase, free tier)

1. In Supabase, open your project (an existing one is fine; WHIRL's tables all start with `whirl_`).
2. **SQL Editor > New query**: paste `setup.sql`, change the two team emails at the bottom, and run it.
3. **Authentication > URL Configuration**: set **Site URL** to `https://keithalanwitter-design.github.io/StormChaseClaude/` and add the same address under **Redirect URLs**.
4. **Project Settings > API**: copy the **Project URL** and the **anon public** key into `config.js`. Never use the `service_role` key.
5. Commit `config.js`. The site redeploys on its own; sign in on the Chase log tab with an email from step 2.

Add a teammate later: `insert into public.whirl_team (email) values ('name@example.com');`

# Prompt Style

These skills follow current OpenAI prompt guidance for GPT-5.5-style coding agents:

- State the role and objective directly.
- Give clear stop conditions and verification criteria.
- Bound context gathering to the files and contracts needed for the task.
- Prefer acting once the edit path is clear.
- Ask concise questions only when ambiguity affects correctness or safety.
- Keep final answers focused on changed files, verification, and remaining risks.
- End completed tasks with a `What to do next` section when a valid follow-up exists; otherwise say no HA follow-up skill is needed.

Source: https://developers.openai.com/api/docs/guides/prompt-guidance

# CIVIX Academy Course Writing Style Guide

**Audience for this guide:** The editor (human or Claude CLI) who revises existing course drafts and prepares them for injection into CIVIX Academy.
**Applies to:** All course content: lessons, callouts, takeaways, mastery checks, course-end reviews, and glossary text.
**Goal:** Text that reads as studious, educational, and human. It should sound like a careful textbook author who knows the subject and respects the reader. It does not need to sound casual, and it does not need to sound perfectly "human." It only needs to avoid the patterns that make writing feel machine-generated.

---

## 1. The one-paragraph version

Write like a good textbook author. Explain ideas in connected paragraphs where the reasoning matters, and use tables, lists, and callouts only where the content is truly a comparison, a sequence, or a reference. Vary sentence length: most sentences are medium, some are short for emphasis, and a few are long and carry two or three related ideas. Use contractions in explanation. Keep a calm, respectful, plain-language tone. Never change a fact, a source flag, a legal caution, or a correct answer while editing for style.

---

## 2. Hard rules: what must NOT change

Style editing must never alter substance. Before and after every edit, confirm that none of these changed.

1. **Facts and claims.** Do not add, remove, soften, or strengthen any factual claim. If a sentence says a source "offers no data," it still says so afterward.
2. **Source flags and honesty notes.** Phrases that mark a source as vendor content, practitioner opinion, a law-firm article, an unofficial page, or old/federal-only must survive. They may be reworded but not dropped.
3. **Legal and compliance cautions.** Keep every "this is not legal advice," "counsel decides," and "ask your leader" statement. Rewording is fine. Removal is not.
4. **Company-specific rules.** Fixed subscription pricing (reps never negotiate, invent prices, or promise different terms; they offer only published plans and official promotions); customer information kept in the company database, non-sensitive only, purged after 365 days of no subscription; non-standard requests go to the right person at Resona. Do not paraphrase these into something weaker.
5. **Correct answers.** The correct option in every mastery check and review must remain the correct option (see Section 8 for permitted changes to option wording and position).
6. **Content-gate rule.** Trainee-facing content must not contain financial sequencing, internal competitive standing, or leadership-only strategic context. If any appears, flag it. Do not silently keep or silently delete it.
7. **Fictional names and labels.** Fictional people and figures stay clearly fictional (the course uses Lena, Marco, and Jordan). Do not turn an example into a real-sounding statistic.
8. **Structure the platform depends on.** Lesson objective callouts, chunked content, retrieval practice, takeaway, "when you're working with a customer" callout, mastery check, and glossary rows (which feed `glossary_terms` and flashcards). Do not remove or rename these. Match whatever the importer already expects.
9. **Author's notes and open items.** Do not delete these during the style pass. Authors' notes are removed as a separate publishing step.

If a style change would require changing any of the above, stop and flag it in a change log instead of making the edit.

---

## 3. Voice

### 3.1 Register

- **Textbook author, not coach or influencer.** Calm, clear, and respectful. The author knows the subject and is explaining it to a capable adult.
- **Third person and second person ("you") are both fine.** Avoid "we" as a teaching voice ("we start defending the price"). Use "we" only when it refers to Resona the company.
- **No personal asides.** No "In my experience," "I've seen," or anecdotes presented as the author's own. Examples are fictional and labeled as such.
- **No hype and no pep talk.** Avoid exclamation points, motivational slogans, and cheerleading.
- **Plain language.** Prefer the shorter, common word unless the precise term is the one learners need to know. When a technical term is introduced, define it once in plain words.

### 3.2 Contractions

- Use contractions in explanatory prose: *isn't, can't, doesn't, you're, it's*.
- Leave them out in formal opening paragraphs, definitions, and any legal or compliance statement, where "is not" and "does not" read as more careful.
- Never mix both in the same sentence.

### 3.3 Sentence rhythm

This is the most important change. Machine-written text tends to be a stream of short, equal-length declarative sentences. Real instructional writing varies.

- **Target mix per paragraph:** mostly medium sentences (roughly 15 to 25 words), at least one longer sentence (30 to 45 words) that joins two or three related ideas with a semicolon, colon, dash, or a connector such as *yet, because, although, which means*, and a short sentence only where a point needs to land.
- **Do not string three or more short sentences in a row** unless it is a deliberate list of steps.
- **Do not make every long sentence a list of three.** Vary the grammar of the long sentences: a cause-and-effect sentence, a contrast, a sentence with a subordinate clause up front.
- **Read it aloud.** If every sentence takes the same breath, rewrite.

### 3.4 Connected reasoning

Where an idea has a reason, give the reason in the same paragraph. Use transitions that carry logic: *because, so, which is why, yet, however, in practice, for example, by contrast*. Machine-written text often drops the logic and leaves only claims.

---

## 4. Patterns to remove (the "machine tells")

Search every file for these and rewrite wherever they occur. They are not banned in all cases, but each one should be rare.

| Pattern | Example from drafts | What to do |
|---|---|---|
| **Staccato fragments** | "Treat it as a question. Listen first. Never argue." | Join into one or two sentences that show how the points relate. |
| **"Not X. It is Y." corrections** | "An objection is not an attack. It is information." | Say the positive point directly, or use the contrast once per lesson at most. |
| **Rule-of-three slogans** | "Be clear. Be calm. Be honest." | Replace with a sentence of reasoning. Use triplets only when there are truly three items. |
| **Poster-style takeaways** | "A no is an answer." | Write the takeaway as a full sentence with its reason. |
| **Over-bolding** | Bold on a phrase in every sentence | Bold only defined terms on first use, speaker labels in dialogues, and labels in "do/do not" lists. |
| **Bullet lists for explanation** | Bullets that are really one idea per line | Convert to a paragraph unless the items are parallel reference material. |
| **Table for everything** | A two-row table that could be a sentence | Keep tables for real comparisons and sequences only. |
| **In-line cross-references** | "(Module 2.1)" after nearly every claim | Remove from body text. Keep at most one per lesson, only where a reader truly needs to go back. Move the rest to the author's notes. |
| **Throat-clearing openers** | "It is important to note that...", "Notice that..." | Delete and start with the point. |
| **Filler intensifiers** | "very," "really," "simply," "just," "crucial," "essential" | Delete unless the word changes the meaning. |
| **Stock AI vocabulary** | "navigate," "landscape," "delve," "leverage," "robust," "seamless," "foster," "crucial," "tapestry," "journey" (except buyer's journey, which is a defined term) | Replace with the plain word. |
| **Tidy final lines** | Every section ending on a neat aphorism | End on the last useful point. Not every section needs a closing line. |
| **Repeated sentence openers** | Six sentences in a row starting with "The" or "You" | Vary the openings. |
| **Em dash overuse** | Em dashes in most paragraphs | Prefer commas, colons, semicolons, or two sentences. At most one em dash per page. |
| **Parallel "Do / Do not" lists everywhere** | Every lesson ends with a do/don't block | Keep where behavior rules matter (ethics, compliance). Elsewhere, write prose. |
| **Generic example dialogues with no texture** | "Customer: ... Rep: ..." that only illustrates the rule | Add one concrete, believable detail that explains why the person said it. |
| **Over-explaining the lesson plan** | "In this lesson you will learn..." paragraphs | Keep the objective callout; do not repeat it in the body. |

---

## 5. Formatting rules

### 5.1 Keep

- The lesson format used in the existing drafts (objective, chunks, retrieval practice, takeaway, working-with-a-customer callout, mastery check, glossary).
- **Tables** where content is a genuine side-by-side comparison, a mapping (type to meaning), or a sequence with several attributes.
- **Mermaid diagrams** where they already exist.
- **Dialogue blocks** for fictional examples, with speaker labels in bold.

### 5.2 Change

- **Explanatory content becomes paragraphs.** If a bulleted or tabled section is explaining *why* something is true, rewrite it as one to three connected paragraphs. If it is a checklist someone will scan, keep it a list.
- **Paragraph length:** 3 to 6 sentences. Break up anything longer than about 150 words.
- **Headings:** Keep headings short and descriptive. Do not use question headings or clever headings.
- **Lists:** When a list stays, keep items parallel in grammar, and introduce the list with a full sentence.
- **Callouts:** Keep the "Objective," "Retrieval Practice," "Takeaway," and "When you're working with a customer" callouts. Their interiors must follow this guide.

### 5.3 Takeaways

Write each takeaway as one to two full sentences that state the idea and the reason. Example:

- **Before:** "An objection is information. Treat it as a question, listen first, and never argue."
- **After:** "An objection gives you information about what the customer still needs to decide, which is why it's best treated as a question to understand rather than an attack to answer."

### 5.4 "When you're working with a customer" callouts

Write one concrete, doable action in a sentence or two. Avoid commands in the imperative stacked on each other. Example:

- **Before:** "When you hear a concern, take a breath and say to yourself, 'That's a question.' Then respond to the question."
- **After:** "When a concern comes up, pause briefly and restate it as a question, such as 'So you're wondering whether your staff would actually use it?', before offering any answer."

### 5.5 Retrieval practice

Keep the three-question format. Questions should be answerable from the lesson, vary in form (recall, application, a short scenario), and not all start with "Name." At least one per lesson should ask the learner to apply an idea to a situation.

---

## 6. Worked examples

### Example A: Explanatory passage (Lesson 6.2)

**Before:**

> The most common mistake is answering the first words, not the real concern. A consulting-site article on LAER warns about this: confidence that you already know the real concern should be treated with suspicion. (That article cites no data, so treat it as practical advice.)
> **Customer:** "That's too much for us." **Weak:** "But it saves you so much time!" **Better:** "Understood. When you say it's too much, is it the monthly cost, or are you not sure yet it would pay off?" The answers lead to different responses.

**After:**

> A common mistake in handling objections is to answer the words a customer used rather than the concern behind them. When a customer says, "That's too much for us," the instinctive response is to defend the price, yet those few words can carry quite different meanings: the monthly amount may truly be beyond the budget, the customer may not yet be convinced the product will pay for itself, or the decision may rest with someone else whose objection the customer is simply anticipating. Each of these calls for a different reply, and from the outside there is no way to tell which one you're facing.
>
> This is why exploring comes before responding. A question such as "When you say it's too much, is it the monthly amount, or are you not sure yet that it would pay off?" accomplishes two things at once. It shows the customer that the comment was taken seriously, and it invites them to say what they actually meant.
>
> > **Customer:** "That's too much for us."
> > **Rushed:** "But it saves you so much time!"
> > **Curious:** "Understood. Is it the monthly amount, or are you not sure yet it would pay off?"
>
> The rushed reply isn't rude, but it answers a question the customer never asked. A consulting-firm article on this method gives the same caution about responding before exploring, though it offers no data, so it's best read as experienced advice rather than proof.

**What changed:** fragments joined into reasoned sentences; one long sentence carrying three related possibilities; the source caveat kept but moved into the flow; table-like "Weak/Better" kept as a short dialogue because it is a true side-by-side; bold limited to speaker labels.

### Example B: Lesson opening

**Before:** "In this lesson you will learn how to ask good questions. Questions are important. They help you understand the customer."

**After:** "Most people assume a good salesperson is one who speaks well, but the habit that separates strong conversations from weak ones is usually listening: asking a question, waiting through the pause that follows, and then responding to what was actually said rather than to what was expected."

### Example C: Takeaway

**Before:** "A no is an answer. Leave well, honor requests to stop, and learn from every objection."

**After:** "A customer who says no after hearing honest information has made a decision, and the professional response is to leave graciously, honor any request to stop contact, and use what the conversation revealed to improve the next one."

### Example D: A list that should stay a list

A required-items checklist (what a customer should know before committing to a subscription: what's included, price, billing start, renewal, how to cancel, who to contact) is reference material and should remain a table or list. Rewrite only the sentences around it.

---

## 7. Citations, sources, and honesty language

- Keep the **Sources** list at the end of each module as-is, except for link fixes.
- In body text, attribute sources in plain words: "an open sales textbook from NSCC," "a law-firm summary from May 2026," "a vendor blog." Avoid inline hyperlinks in body text unless the platform renders them well.
- Keep honest limitation language, but write it as a normal sentence: "that article offers no data, so treat it as practical advice." Do not turn caveats into long disclaimers, and do not drop them.
- Do not introduce new sources or statistics during style editing. If a sentence seems to need support, flag it instead.
- Use plain words for uncertainty: "the sources I read don't say," "counsel should confirm." Avoid hedging stacks ("it may perhaps be possible that...").

---

## 8. Mastery checks and course-end reviews

Style editing may touch question wording, but it must not alter what is being tested or which answer is correct.

### 8.1 Allowed

- Tighten question stems into clear, neutral language.
- **Vary the length of the options.** In the current drafts the correct option is usually the longest and most carefully worded, which lets test-takers guess without reading. Make distractors plausible and similar in length and detail to the correct answer.
- **Vary the position of the correct answer.** Aim for a roughly even spread across A, B, C, and D within each check. Where the importer expects a specific marker for the correct answer, keep that marker format and move it with the option.
- Rewrite distractors so each reflects a believable misunderstanding, not an obviously silly choice. Avoid distractors that are rude, absurd, or jokes.
- Add a one- or two-sentence explanation for each question if the platform supports it, written in this guide's voice.

### 8.2 Not allowed

- Changing the concept being tested.
- Creating a question with more than one defensible correct answer. After rewriting, check that exactly one option is correct.
- Using "all of the above," "none of the above," or "both A and B."
- Making a question depend on a fictional statistic.

### 8.3 Review count

Keep the existing counts (8 questions per module mastery check, 12 in the Sales Essentials course-end review), unless the platform's exam pool logic requires otherwise.

---

## 9. Glossary text

- Definitions are one sentence, in plain words, and begin with the category the term belongs to ("A federal law that..." "A question that...").
- Do not use the term in its own definition.
- Keep the table format; each row maps to a `glossary_terms` entry used by flashcards.
- Keep terms in sentence case unless they are proper nouns or acronyms.

---

## 10. Cross-references and numbering

The drafts contain many "(Module X.Y)" references, and in the Procurement in Practice course Modules 1 to 6 still carry older module numbers from before the course was reorganized.

1. Build a map of the final module and lesson numbering for each course before editing.
2. Remove most inline cross-references from body text (see Section 4).
3. Where a cross-reference stays, write it in words ("the earlier lesson on discovery") and update it to the final number or name.
4. Log any cross-reference you could not resolve.

---

## 11. Editing procedure

For each module file:

1. **Read the whole module first.** Note the lesson structure, the source flags, and the company-specific rules.
2. **Edit in passes, not line by line:**
   - Pass 1: Convert explanatory tables and bullet lists into paragraphs (Section 5.2). Keep true comparisons.
   - Pass 2: Fix sentence rhythm (Section 3.3) and remove machine tells (Section 4).
   - Pass 3: Rewrite takeaways and "working with a customer" callouts (5.3, 5.4).
   - Pass 4: Revise mastery checks (Section 8) and glossary (Section 9).
   - Pass 5: Clean cross-references (Section 10).
3. **Read the result aloud or scan for rhythm.** If three sentences in a row have the same length and shape, vary them.
4. **Run the checklist in Section 12.**
5. **Write a change log** for the module: what was restructured, what was flagged, any unresolved issue.

Do not rewrite for length. The edited module should be roughly the same length as the draft, and may be a little shorter once filler is removed.

---

## 12. Quality checklist (run on every module)

**Substance**
- [ ] Every factual claim, source flag, and legal caution from the draft is still present.
- [ ] Company-specific rules (fixed pricing, data handling, escalation) are intact and worded at least as firmly.
- [ ] No new statistic, source, or claim has been introduced.
- [ ] No financial sequencing, internal competitive standing, or leadership-only context is present (or it has been flagged).
- [ ] Exactly one correct option per question, and it is the same concept as before.

**Voice**
- [ ] Reads like a textbook author: calm, plain, no hype, no personal asides.
- [ ] Contractions used in explanation, not in formal or legal sentences.
- [ ] No "we" used as a teaching voice.

**Rhythm**
- [ ] Each paragraph has at least one longer sentence and no run of three or more same-length short sentences.
- [ ] Sentence openers vary.
- [ ] Em dashes: at most one per page.

**Machine tells**
- [ ] No slogan takeaways, "not X, it is Y" pairs (more than one per lesson), or throat-clearing openers.
- [ ] Bold used only for defined terms, speaker labels, and list labels.
- [ ] Stock vocabulary replaced with plain words.
- [ ] Cross-references minimized and updated.

**Format**
- [ ] Required lesson structure intact.
- [ ] Tables kept only for true comparisons or sequences.
- [ ] Glossary rows intact and in importer format.
- [ ] Mastery check options vary in length and the correct answer's position is spread across A to D.

---

## 13. When to stop and flag instead of editing

Flag in the change log, and do not edit around the problem, when:

- A claim looks wrong, outdated, or unsupported.
- A legal or compliance statement seems to conflict with another module.
- A source link does not resolve. (Several URLs in the Sales Essentials drafts were written from research notes and should be checked.)
- A fictional example could be mistaken for a real statistic or a real company.
- The lesson depends on information the company has not yet provided. Known open items include a named role for non-standard requests, a written contact policy for calls, texts, and email, an approved-claims list and reviews policy, published plan and promotion names, and counsel review of the privacy, contact-rules, FTC-claims, and ethics lessons.

---

## 14. Quick reference: before-and-after phrases

| Instead of | Write |
|---|---|
| "It is important to note that" | (delete and start with the point) |
| "Make sure you" | "You'll want to" or state the action directly |
| "Utilize" | "use" |
| "In order to" | "to" |
| "Leverage" | "use" or "draw on" |
| "Navigate a conversation" | "handle a conversation" |
| "A key takeaway is" | (state the takeaway) |
| "Always" and "never" (in advice) | "usually" and "rarely," unless it's a rule or a legal line |
| "Powerful," "game-changing," "crucial" | (delete, or give the specific reason) |
| "Simply" and "just" | (delete) |
| "Let's dive in" | (delete) |

-- =============================================================
-- comments_additional.sql
-- Adds 2-3 comments to the 128 posts that currently have NO comments
-- Run ONCE on clean state — comment table uses auto-increment PK
-- =============================================================

USE uni_conn;
SET SQL_SAFE_UPDATES = 0;

-- =============================================================
-- Additional comments with varied counts (5-15 per post)
-- High engagement posts get more comments to match their like counts
-- =============================================================

INSERT INTO comment (post_id, author_id, content_text, created_at, is_deleted) VALUES

-- JPA N+1 post (165) — 10 more comments
(165, 4,  'This saved our capstone project. We had 47 N+1 queries and had no idea.', '2026-04-08 15:00:00', false),
(165, 5,  'EntityGraph vs JOIN FETCH — when do you use each one?', '2026-04-08 15:30:00', false),
(165, 6,  'The @BatchSize annotation is another option worth exploring here.', '2026-04-08 16:00:00', false),
(165, 7,  'Hibernate show_sql=true is the first thing I enable on any new project now.', '2026-04-08 16:30:00', false),
(165, 8,  'We cut our API response time in half just by fixing two N+1 queries.', '2026-04-08 17:00:00', false),
(165, 9,  'Does this approach work with Spring Data specifications?', '2026-04-08 17:30:00', false),
(165, 10, 'The query count going from 47 to 3 is the kind of optimization that matters.', '2026-04-08 18:00:00', false),
(165, 13, 'Adding p6spy to the dependencies for query logging changed everything for us.', '2026-04-08 18:30:00', false),

-- Pandas vs Polars (176) — 12 more comments
(176, 4,  'Polars syntax is different but once it clicks you never want to go back.', '2026-04-11 15:00:00', false),
(176, 5,  'Tried it on a 500MB dataset. The difference is night and day.', '2026-04-11 15:30:00', false),
(176, 6,  'The lazy evaluation model is what makes it so fast for large pipelines.', '2026-04-11 16:00:00', false),
(176, 7,  'Does Polars integrate well with scikit-learn or do you need to convert back?', '2026-04-11 16:30:00', false),
(176, 8,  'You need to convert to numpy or pandas for sklearn. Minor friction.', '2026-04-11 17:00:00', false),
(176, 9,  'The expression API took me a week but now it feels more intuitive than pandas.', '2026-04-11 17:30:00', false),
(176, 10, 'Worth switching for anything over 100MB in my experience.', '2026-04-11 18:00:00', false),
(176, 13, 'The group_by syntax is cleaner in Polars. Less boilerplate overall.', '2026-04-11 18:30:00', false),
(176, 14, 'Starting a new project with Polars from scratch this semester.', '2026-04-11 19:00:00', false),
(176, 15, 'Benchmarked it against pandas on our ML pipeline. 8x faster on aggregations.', '2026-04-11 19:30:00', false),

-- Full-Stack Architecture (187) — 15 more comments
(187, 3,  'React plus TypeScript makes the frontend so much more maintainable.', '2026-03-29 15:00:00', false),
(187, 5,  'We added Redis for session caching and it cut our DB load significantly.', '2026-03-29 15:30:00', false),
(187, 6,  'The advice about not mixing frameworks early on saved us a full sprint.', '2026-03-29 16:00:00', false),
(187, 7,  'What do you use for deployment? AWS or something simpler?', '2026-03-29 16:30:00', false),
(187, 8,  'Railway for quick deploys, AWS for anything that needs to scale.', '2026-03-29 17:00:00', false),
(187, 9,  'The testing section is the most underrated part. So many teams skip it.', '2026-03-29 17:30:00', false),
(187, 10, 'JUnit for backend, React Testing Library for frontend. That combo works.', '2026-03-29 18:00:00', false),
(187, 11, 'Two semesters of projects and this is the most practical advice I have seen.', '2026-03-29 18:30:00', false),
(187, 14, 'The database migration section using Flyway changed how our team works.', '2026-03-29 19:00:00', false),
(187, 15, 'Avoiding ORM for complex queries and using native SQL is underappreciated advice.', '2026-03-29 19:30:00', false),
(187, 16, 'We followed this exact stack and shipped our MVP in 6 weeks.', '2026-03-29 20:00:00', false),
(187, 17, 'The CI/CD section is what most student projects completely ignore.', '2026-03-29 20:30:00', false),
(187, 18, 'GitHub Actions for CI plus Railway for CD is the student project sweet spot.', '2026-03-29 21:00:00', false),

-- CTF Team post (227) — 10 more comments
(227, 3,  'I specialize in forensics and steganography. Count me in.', '2026-03-31 15:00:00', false),
(227, 4,  'SQL injection challenges are where I spend most of my CTF time.', '2026-03-31 15:30:00', false),
(227, 5,  'Binary exploitation is my weakness. Need to practice more pwn challenges.', '2026-03-31 16:00:00', false),
(227, 6,  'PicoCTF is perfect for beginners. The difficulty curve is well designed.', '2026-03-31 16:30:00', false),
(227, 7,  'HackTheBox after PicoCTF is the natural progression. Great recommendation.', '2026-03-31 17:00:00', false),
(227, 9,  'What tools does everyone use for network challenges? Wireshark and what else?', '2026-03-31 17:30:00', false),
(227, 10, 'Wireshark, Burp Suite, and pwntools cover 90% of what you need.', '2026-03-31 18:00:00', false),
(227, 11, 'The team Discord idea is great. Coordination during a 48-hour CTF is crucial.', '2026-03-31 18:30:00', false),

-- Gamification post (209) — 8 more comments
(209, 2,  'The streak mechanic you described is exactly what Duolingo uses. Smart.', '2026-04-04 17:00:00', false),
(209, 4,  'Rewards for consistency not just completion is the key design insight here.', '2026-04-04 17:30:00', false),
(209, 5,  'Did you A/B test the badge designs? Curious what visual style worked best.', '2026-04-04 18:00:00', false),
(209, 7,  'The 40% engagement increase number is impressive. What was your sample size?', '2026-04-04 18:30:00', false),
(209, 8,  '28 students over 3 weeks. Not huge but the trend was consistent.', '2026-04-04 19:00:00', false),
(209, 10, 'Gamification working better for shorter sessions is a useful finding.', '2026-04-04 19:30:00', false),

-- Profile posts — varied comment counts
-- High engagement profile post (269) — 8 more comments
(269, 2,  'Polars changed how I think about data transformations entirely.', '2026-04-22 17:00:00', false),
(269, 4,  'The syntax is verbose at first but the performance is worth learning it.', '2026-04-22 17:30:00', false),
(269, 6,  'What dataset size do you recommend before switching from pandas?', '2026-04-22 18:00:00', false),
(269, 7,  'Anything over 50MB is where you start to feel the difference.', '2026-04-22 18:30:00', false),
(269, 8,  'The streaming mode for out-of-memory datasets is a game changer.', '2026-04-22 19:00:00', false),
(269, 10, 'Lazy evaluation clicks when you realize it only runs what you actually need.', '2026-04-22 19:30:00', false),

-- Medium engagement profile post (286) — 6 more comments
(286, 4,  'AI music is at the uncanny valley stage right now. Close but not quite.', '2026-04-24 17:00:00', false),
(286, 5,  'The emotional authenticity gap is what separates human from AI performance.', '2026-04-24 17:30:00', false),
(286, 7,  'I wonder if the issue is training data or the architecture itself.', '2026-04-24 18:00:00', false),
(286, 8,  'Probably both. Models trained on MIDI lose so much expressive nuance.', '2026-04-24 18:30:00', false),
(286, 9,  'When it does move you will it matter that it was generated? Genuine question.', '2026-04-24 19:00:00', false),

-- Low engagement profile post (270) — 4 more comments
(270, 2,  'datetime64 bugs in pandas are responsible for at least 30% of my debugging time.', '2026-04-14 15:00:00', false),
(270, 4,  'The timezone handling is where it gets really painful.', '2026-04-14 15:30:00', false),
(270, 6,  'Always store in UTC. Localize at display time. The one rule that saves everything.', '2026-04-14 16:00:00', false);

-- Sync comment_count after all inserts
UPDATE post SET comment_count = (
    SELECT COUNT(*) FROM comment WHERE post_id = post.post_id AND is_deleted = false
);

SET SQL_SAFE_UPDATES = 1;

-- Verify
SELECT COUNT(*) AS total_comments FROM comment;
SELECT COUNT(*) AS posts_with_no_comments FROM post
WHERE is_deleted = false
AND post_id NOT IN (SELECT DISTINCT post_id FROM comment);
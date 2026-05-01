-- =============================================================
-- comments_test_data.sql
-- Run AFTER posts_test_data.sql
-- INSERT IGNORE not used here since comment has auto-increment PK
-- Safe to run once — check COUNT(*) FROM comment = 0 before running
-- Post IDs start at 161 in this database
-- =============================================================

USE uni_conn;
SET SQL_SAFE_UPDATES = 0;

INSERT INTO comment (post_id, author_id, content_text, created_at, is_deleted) VALUES
-- Post 161 (alex_m92, CS_Capstone — Capstone Kickoff)
(161, 4,  'I am thinking of building a student marketplace — buy and sell textbooks between CSUN students.', '2026-03-29 22:30:00', false),
(161, 12, 'Real-time collaborative editor sounds amazing. Are you thinking WebSockets or polling?', '2026-03-29 23:00:00', false),
(161, 21, 'We are going with a task management app for student groups. Simple but functional.', '2026-03-30 08:00:00', false),

-- Post 162 (carlos_v, CS_Capstone — REST vs GraphQL)
(162, 2,  'We went with REST and honestly for a class project it is the right call. Less overhead.', '2026-03-31 22:30:00', false),
(162, 19, 'GraphQL is worth it if your frontend needs are complex, otherwise REST is fine.', '2026-04-01 08:00:00', false),
(162, 12, 'REST is easier to test in Postman too which matters for class demos.', '2026-04-01 10:00:00', false),

-- Post 163 (kevin_nb, CS_Capstone — JPA N+1)
(163, 2,  'Hit this exact issue last week. EntityGraph saved us.', '2026-04-03 22:30:00', false),
(163, 21, 'What about using JOIN FETCH in JPQL? Is that equivalent?', '2026-04-03 23:00:00', false),
(163, 14, 'We had the same problem with our community member queries. Thanks for sharing the fix.', '2026-04-04 08:00:00', false),

-- Post 164 (miguel_cr, CS_Capstone — Database Schema)
(164, 2,  'The denormalized count column pattern is a good call for read performance.', '2026-04-06 22:30:00', false),
(164, 12, 'Your join table for tags looks clean. Are you using composite keys?', '2026-04-07 08:00:00', false),
(164, 4,  'Would love to see the ER diagram. Can you share a link?', '2026-04-07 10:00:00', false),
(164, 19, 'We had 11 tables originally but trimmed it down. Less is more for class projects.', '2026-04-07 12:00:00', false),

-- Post 165 (raj_pt, CS_Capstone — ML Search)
(165, 3,  'We did something similar with a Python Flask microservice. Happy to share notes.', '2026-04-08 22:30:00', false),
(165, 11, 'Cross-language REST calls work great. Just watch out for latency if the model is big.', '2026-04-09 08:00:00', false),
(165, 12, 'How are you handling the model versioning? Curious about your deployment plan.', '2026-04-09 10:00:00', false),

-- Post 166 (tyler_mc, CS_Capstone — Mockito)
(166, 2,  'Mockito is a game changer once you get the hang of it. Would love that template.', '2026-04-10 22:30:00', false),
(166, 12, 'We use @ExtendWith(MockitoExtension.class) on every test class. Makes setup way cleaner.', '2026-04-11 08:00:00', false),
(166, 4,  'Please share the template. Our test coverage is basically zero right now.', '2026-04-11 10:00:00', false),

-- Post 167 (alex_m92, CS_Capstone — Docker Compose)
(167, 4,  'Please share the docker-compose.yml. We have been running locally with different MySQL versions.', '2026-04-13 22:30:00', false),
(167, 21, 'Docker Compose fixed so many team issues for us. Highly recommend.', '2026-04-14 08:00:00', false),
(167, 12, 'Does it work on Windows without WSL2? That is where we keep running into issues.', '2026-04-14 10:00:00', false),

-- Post 168 (carlos_v, CS_Capstone — CORS)
(168, 2,  'The WebMvcConfigurer bean fix is exactly what we needed last sprint.', '2026-04-16 22:30:00', false),
(168, 21, 'We also had to add the Authorization header to the allowedHeaders list. Easy to miss.', '2026-04-17 08:00:00', false),
(168, 19, 'Documenting fixes like this should be required for every team. Great post.', '2026-04-17 10:00:00', false),

-- Post 169 (kevin_nb, CS_Capstone — Soft Delete)
(169, 2,  'We use the same pattern. The @Where annotation is magical once you get it.', '2026-04-18 22:30:00', false),
(169, 14, 'How do you handle cascading soft deletes? For example if a community is soft deleted.', '2026-04-19 08:00:00', false),
(169, 21, 'Good pattern for audit trails too. Nothing is ever truly gone which is nice.', '2026-04-19 10:00:00', false),

-- Post 170 (raj_pt, CS_Capstone — Python Seeding)
(170, 2,  'Please share the script. Writing INSERT statements by hand for 100 users was painful.', '2026-04-20 22:30:00', false),
(170, 12, 'We used Faker library in Python for this. Generates realistic names, emails, etc.', '2026-04-21 08:00:00', false),
(170, 4,  'Does it handle foreign key ordering automatically? That was the tricky part for us.', '2026-04-21 10:00:00', false),

-- Post 173 (brianna_t, DataScience_Hub — Best Python Libraries)
(173, 11, 'Missingno is so underrated. Added it to our pipeline last week.', '2026-03-29 22:30:00', false),
(173, 20, 'Have you tried ydata-profiling for full EDA reports? One line of code.', '2026-03-30 08:00:00', false),

-- Post 178 (brianna_t, DataScience_Hub — Pandas vs Polars)
(178, 11, 'Switched last month and never going back. The speed improvement is real.', '2026-04-11 22:30:00', false),
(178, 20, 'Lazy evaluation was confusing at first but makes total sense once it clicks.', '2026-04-12 08:00:00', false),

-- Post 179 (jasmine_hl, DataScience_Hub — AI APIs)
(179, 3,  'This is such a creative use of LLM APIs. Did you try any open source models?', '2026-04-14 22:30:00', false),
(179, 19, 'The feature engineering use case is brilliant. Would love to see a writeup.', '2026-04-15 08:00:00', false),

-- Post 180 (kevin_nb, DataScience_Hub — Confusion Matrix)
(180, 3,  'F1 score is underrated. So many teams just report accuracy and miss the whole picture.', '2026-04-17 22:30:00', false),
(180, 11, 'Can you share the walkthrough? This would be great for our model evaluation section.', '2026-04-18 08:00:00', false),

-- Post 181 (raj_pt, DataScience_Hub — Free Datasets)
(181, 3,  'Adding World Bank Open Data to this list. Great for economics datasets.', '2026-04-19 22:30:00', false),
(181, 11, 'Kaggle is my go-to but UCI has some gems that are less overused for class projects.', '2026-04-20 08:00:00', false),
(181, 20, 'GitHub also has a curated awesome-public-datasets list worth bookmarking.', '2026-04-20 10:00:00', false),

-- Post 182 (sofia_er, DataScience_Hub — Neural Network Activations)
(182, 3,  'This is exactly what I needed for my deep learning project. Please share the notebook.', '2026-04-22 22:30:00', false),
(182, 11, 'PyTorch hooks are so powerful. Most people do not know about them.', '2026-04-23 08:00:00', false),

-- Post 183 (brianna_t, DataScience_Hub — ML Pipeline)
(183, 11, 'The step from sklearn to FastAPI is where most teams get stuck. Great end-to-end writeup.', '2026-04-26 22:30:00', false),
(183, 20, 'Would love to see the React dashboard code. How did you handle real-time predictions?', '2026-04-27 08:00:00', false),
(183, 19, 'This is the most complete pipeline writeup I have seen in this community.', '2026-04-27 10:00:00', false),

-- Post 226 (george_lp, CyberSec_CTF — CTF Team Formation)
(226, 2,  'I am in. Strong in web exploitation and have done a few forensics challenges.', '2026-04-03 22:30:00', false),
(226, 19, 'Count me in for the crypto challenges. That is where I am strongest.', '2026-04-04 08:00:00', false),

-- Post 237 (hannah_s9, PreMed_Network — MCAT Study Schedule)
(237, 15, 'This schedule is exactly what I needed. Starting today.', '2026-04-02 22:30:00', false),
(237, 17, 'The CARS from day one advice is so important. I wish I had started earlier.', '2026-04-03 08:00:00', false),
(237, 20, '515 is incredible. Did you use a tutor or self-study only?', '2026-04-03 10:00:00', false),

-- Post 256 (jasmine_hl, Music_And_AI — Welcome)
(256, 3,  'Working on a playlist generation model that accounts for mood and time of day.', '2026-04-03 22:30:00', false),
(256, 20, 'Building a real-time transcription tool for live performances. Excited to share progress.', '2026-04-04 08:00:00', false);

-- Update comment_count on posts to match
UPDATE post SET comment_count = (
    SELECT COUNT(*) FROM comment WHERE post_id = post.post_id AND is_deleted = false
);

SET SQL_SAFE_UPDATES = 1;

-- Verify
SELECT COUNT(*) AS total_comments FROM comment;
SELECT post_id, comment_count FROM post WHERE post_id IN (161, 162, 163, 164, 183) ORDER BY post_id;

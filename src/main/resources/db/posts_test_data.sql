-- ============================================================
-- posts_test_data.sql
-- Run AFTER users_test_data.sql AND community_test_data.sql
--
-- 150 Posts total:
--   105 Community posts (title + contentText, community_id set)
--    45 Profile posts   (no title, no community_id — Twitter-style)
--
-- Tag rules:
--   - Max 5 tags per post
--   - Tags weighted toward community themes, with cross-topic overlap
--     so that python, machinelearning, react, java, etc. trend visibly
--   - Profile posts may have 0–3 tags
--
-- Community membership reference:
--   CS_Capstone      : alex_m92(A), carlos_v(M), kevin_nb, miguel_cr, raj_pt, tyler_mc
--   DataScience_Hub  : brianna_t(A), jasmine_hl(M), kevin_nb, raj_pt, sofia_er
--   FullStack_Dev    : carlos_v(A), alex_m92(M), ethan_rc, kevin_nb, laura_fd, miguel_cr, tyler_mc
--   Robotics_Club    : diana_wu(A), ivan_mk(M), miguel_cr, omar_hs, tyler_mc
--   EdTech_Builders  : ethan_rc(A), laura_fd(M), natalie_bw, quinn_aj
--   UX_Design_CSUN   : fatima_ok(A), laura_fd(M), natalie_bw, paula_gm, quinn_aj
--   CyberSec_CTF     : george_lp(A), alex_m92(M), kevin_nb, omar_hs, raj_pt
--   PreMed_Network   : hannah_s9(A), natalie_bw(M), paula_gm, sofia_er
--   Formula_SAE      : ivan_mk(A), diana_wu(M), miguel_cr, omar_hs
--   Music_And_AI     : jasmine_hl(A), brianna_t(M), laura_fd, quinn_aj, sofia_er
-- ============================================================
USE uni_conn;

-- ============================================================
-- HELPER: disable safe update mode for sync at the end
-- ============================================================
SET SQL_SAFE_UPDATES = 0;


-- ============================================================
-- COMMUNITY POSTS (105)
-- ============================================================

-- ------------------------------------------------------------
-- CS_Capstone (12 posts)
-- Members: alex_m92, carlos_v, kevin_nb, miguel_cr, raj_pt, tyler_mc
-- Primary tags: java, springboot, databases
-- Cross-topic tags mixed in: python, webdev, fullstack, react, machinelearning
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Capstone Kickoff — Project Ideas Thread',
  'Hey everyone! Let''s use this post to share our capstone project ideas. I''m thinking of building a real-time collaborative code editor with a Spring Boot backend and React frontend. Drop yours below.',
  14, 8, NOW() - INTERVAL 30 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'carlos_v'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'REST vs GraphQL for Our Backend — Which Should We Pick?',
  'Our team is debating REST vs GraphQL for the capstone API. REST is simpler and we all know it, but GraphQL would let the frontend query exactly what it needs. Anyone dealt with this tradeoff before in a class project?',
  9, 6, NOW() - INTERVAL 28 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'JPA N+1 Query Problem — How We Fixed It',
  'Ran into the classic N+1 issue when fetching posts with their tags. Solved it with @EntityGraph on the repository method. Sharing the fix here since a few of you mentioned similar slowdowns in your projects.',
  21, 5, NOW() - INTERVAL 25 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Database Schema Review — Feedback Wanted',
  'Posting our ER diagram for feedback before we finalize the schema. We have 9 tables including a denormalized count column pattern. Main concern is whether our join table design for tags is clean enough.',
  7, 11, NOW() - INTERVAL 22 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Adding ML-Based Search to a Spring Boot App',
  'Experimenting with adding a basic ML recommendation engine to our capstone. Using a Python microservice for the model and calling it from Spring Boot via REST. Anyone done cross-language microservice communication before?',
  18, 9, NOW() - INTERVAL 20 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'tyler_mc'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Unit Testing Spring Boot Services with Mockito',
  'Just finished writing test coverage for our service layer. Using Mockito to mock the repository layer — it was painful at first but worth it. Happy to share the test template we ended up with.',
  12, 4, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Docker Compose Setup for Local Dev',
  'Set up Docker Compose with MySQL + Spring Boot for our whole team so everyone runs the same environment. No more "works on my machine." Will post the docker-compose.yml if anyone wants it.',
  25, 7, NOW() - INTERVAL 15 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'carlos_v'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'React Frontend Integration — CORS Issues and How We Fixed Them',
  'Spent a whole afternoon on CORS errors between our React dev server and Spring Boot. The fix was a simple WebMvcConfigurer bean but finding that took forever. Documenting it here so no one else wastes that time.',
  16, 6, NOW() - INTERVAL 12 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Soft Delete Pattern in JPA',
  'Implemented soft delete with an isDeleted boolean and a @Where annotation on the entity. This way data is never permanently lost. Would recommend this pattern for any app with user-generated content.',
  10, 3, NOW() - INTERVAL 10 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Using Python Scripts for DB Seeding',
  'Wrote a Python script that auto-generates realistic seed data for our MySQL database. Way faster than writing INSERT statements by hand. Can share the script if there''s interest.',
  8, 5, NOW() - INTERVAL 8 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Final Presentation Slide Deck — Outline Help',
  'Working on the capstone final presentation. Anyone have tips on structure? I''m thinking: problem statement → architecture overview → live demo → lessons learned → Q&A.',
  6, 9, NOW() - INTERVAL 5 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'tyler_mc'),
  (SELECT community_id FROM community WHERE community_name = 'CS_Capstone'),
  'Pagination with Spring Data — Pageable Tips',
  'If you''re returning large lists from your API, use Spring Data''s Pageable interface. Took our post-list endpoint from 800ms to under 50ms once we stopped fetching the entire table.',
  19, 4, NOW() - INTERVAL 3 DAY, false
);

-- CS_Capstone post_tag inserts
INSERT INTO post_tag (post_id, tag_id) VALUES
-- Post 1: alex_m92 - Capstone Kickoff
((SELECT post_id FROM post WHERE title = 'Capstone Kickoff — Project Ideas Thread'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'Capstone Kickoff — Project Ideas Thread'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Capstone Kickoff — Project Ideas Thread'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Capstone Kickoff — Project Ideas Thread'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),

-- Post 2: carlos_v - REST vs GraphQL
((SELECT post_id FROM post WHERE title = 'REST vs GraphQL for Our Backend — Which Should We Pick?'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'REST vs GraphQL for Our Backend — Which Should We Pick?'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'REST vs GraphQL for Our Backend — Which Should We Pick?'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

-- Post 3: kevin_nb - JPA N+1
((SELECT post_id FROM post WHERE title = 'JPA N+1 Query Problem — How We Fixed It'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'JPA N+1 Query Problem — How We Fixed It'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'JPA N+1 Query Problem — How We Fixed It'), (SELECT tag_id FROM tag WHERE name = 'databases')),

-- Post 4: miguel_cr - DB Schema Review
((SELECT post_id FROM post WHERE title = 'Database Schema Review — Feedback Wanted'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Database Schema Review — Feedback Wanted'), (SELECT tag_id FROM tag WHERE name = 'java')),

-- Post 5: raj_pt - ML-Based Search
((SELECT post_id FROM post WHERE title = 'Adding ML-Based Search to a Spring Boot App'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Adding ML-Based Search to a Spring Boot App'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Adding ML-Based Search to a Spring Boot App'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Adding ML-Based Search to a Spring Boot App'), (SELECT tag_id FROM tag WHERE name = 'java')),

-- Post 6: tyler_mc - Unit Testing
((SELECT post_id FROM post WHERE title = 'Unit Testing Spring Boot Services with Mockito'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'Unit Testing Spring Boot Services with Mockito'), (SELECT tag_id FROM tag WHERE name = 'springboot')),

-- Post 7: alex_m92 - Docker Compose
((SELECT post_id FROM post WHERE title = 'Docker Compose Setup for Local Dev'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'Docker Compose Setup for Local Dev'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Docker Compose Setup for Local Dev'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),

-- Post 8: carlos_v - React CORS
((SELECT post_id FROM post WHERE title = 'React Frontend Integration — CORS Issues and How We Fixed Them'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'React Frontend Integration — CORS Issues and How We Fixed Them'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'React Frontend Integration — CORS Issues and How We Fixed Them'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),

-- Post 9: kevin_nb - Soft Delete
((SELECT post_id FROM post WHERE title = 'Soft Delete Pattern in JPA'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'Soft Delete Pattern in JPA'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Soft Delete Pattern in JPA'), (SELECT tag_id FROM tag WHERE name = 'springboot')),

-- Post 10: raj_pt - Python DB Seeding
((SELECT post_id FROM post WHERE title = 'Using Python Scripts for DB Seeding'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Using Python Scripts for DB Seeding'), (SELECT tag_id FROM tag WHERE name = 'databases')),

-- Post 11: miguel_cr - Final Presentation
((SELECT post_id FROM post WHERE title = 'Final Presentation Slide Deck — Outline Help'), (SELECT tag_id FROM tag WHERE name = 'java')),

-- Post 12: tyler_mc - Pagination
((SELECT post_id FROM post WHERE title = 'Pagination with Spring Data — Pageable Tips'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'Pagination with Spring Data — Pageable Tips'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Pagination with Spring Data — Pageable Tips'), (SELECT tag_id FROM tag WHERE name = 'databases'));


-- ------------------------------------------------------------
-- DataScience_Hub (11 posts)
-- Members: brianna_t, jasmine_hl, kevin_nb, raj_pt, sofia_er
-- Primary tags: python, machinelearning, datavisualization
-- Cross-topic: java, artificialintelligence, databases, react
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Best Python Libraries for EDA in 2025',
  'For exploratory data analysis, my current go-to stack is pandas + seaborn + missingno. Missingno is underrated for visualizing missing data patterns. What are you all using?',
  22, 10, NOW() - INTERVAL 29 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Music Genre Classification with ML — Project Share',
  'Built a genre classifier using a CNN on Mel spectrograms. Trained on 10k tracks and got 87% accuracy on the test set. The hardest part was preprocessing audio — librosa saved my life.',
  30, 14, NOW() - INTERVAL 27 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Storing ML Model Outputs in MySQL — Schema Design',
  'Trying to persist model predictions back to our relational database. Wondering if storing JSON blobs in a TEXT column is acceptable or if I should normalize predictions into their own table.',
  11, 7, NOW() - INTERVAL 24 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Overfitting Survival Guide for Class Projects',
  'Quick checklist for anyone whose model performs great on training data but tanks on validation: check dataset size, add dropout, try cross-validation, and reduce model complexity before anything else.',
  18, 6, NOW() - INTERVAL 21 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Interactive Data Dashboards with Plotly and Dash',
  'Built a dashboard for our DS project using Plotly Dash. It''s basically React-level interactivity without writing any JavaScript. Highly recommend for quick data storytelling.',
  15, 5, NOW() - INTERVAL 19 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Pandas vs Polars — Is It Worth Switching?',
  'Tried Polars on a 2GB CSV that was making pandas crawl. Load time went from 40s to 3s. Syntax is different but the lazy evaluation model is a game changer. Anyone else made the switch?',
  27, 12, NOW() - INTERVAL 17 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Using AI APIs for Feature Engineering',
  'Experimented with using a language model API to auto-generate feature descriptions from raw column names. It''s surprisingly useful when you have a dataset with cryptic variable names.',
  13, 8, NOW() - INTERVAL 14 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Confusion Matrix Deep Dive — Beyond Accuracy',
  'Stop reporting only accuracy. For imbalanced datasets, look at precision, recall, and F1. I''ll walk through how to interpret each metric and when each one matters more.',
  20, 9, NOW() - INTERVAL 11 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Free Datasets Worth Bookmarking',
  'Building a class project but have no data? Here are my favorite sources: Kaggle, UCI ML Repository, Google Dataset Search, NOAA for climate data, and data.gov for public US datasets.',
  24, 7, NOW() - INTERVAL 9 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'Visualizing Neural Network Activations',
  'Used Matplotlib and hooks in PyTorch to visualize what each layer of a CNN is "looking at." Really demystified how the model actually works. Happy to share the notebook.',
  17, 6, NOW() - INTERVAL 6 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  (SELECT community_id FROM community WHERE community_name = 'DataScience_Hub'),
  'End-to-End ML Pipeline — From CSV to Deployed API',
  'Documented our full pipeline: data cleaning in pandas → feature engineering → sklearn model → FastAPI endpoint → React dashboard. This post covers the architecture decisions at each step.',
  31, 15, NOW() - INTERVAL 2 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'Best Python Libraries for EDA in 2025'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Best Python Libraries for EDA in 2025'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),
((SELECT post_id FROM post WHERE title = 'Best Python Libraries for EDA in 2025'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),

((SELECT post_id FROM post WHERE title = 'Music Genre Classification with ML — Project Share'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Music Genre Classification with ML — Project Share'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Music Genre Classification with ML — Project Share'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Music Genre Classification with ML — Project Share'), (SELECT tag_id FROM tag WHERE name = 'music')),

((SELECT post_id FROM post WHERE title = 'Storing ML Model Outputs in MySQL — Schema Design'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Storing ML Model Outputs in MySQL — Schema Design'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Storing ML Model Outputs in MySQL — Schema Design'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Overfitting Survival Guide for Class Projects'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Overfitting Survival Guide for Class Projects'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Interactive Data Dashboards with Plotly and Dash'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),
((SELECT post_id FROM post WHERE title = 'Interactive Data Dashboards with Plotly and Dash'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Interactive Data Dashboards with Plotly and Dash'), (SELECT tag_id FROM tag WHERE name = 'react')),

((SELECT post_id FROM post WHERE title = 'Pandas vs Polars — Is It Worth Switching?'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Pandas vs Polars — Is It Worth Switching?'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),

((SELECT post_id FROM post WHERE title = 'Using AI APIs for Feature Engineering'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Using AI APIs for Feature Engineering'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Using AI APIs for Feature Engineering'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Confusion Matrix Deep Dive — Beyond Accuracy'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Confusion Matrix Deep Dive — Beyond Accuracy'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Confusion Matrix Deep Dive — Beyond Accuracy'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),

((SELECT post_id FROM post WHERE title = 'Free Datasets Worth Bookmarking'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Free Datasets Worth Bookmarking'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Free Datasets Worth Bookmarking'), (SELECT tag_id FROM tag WHERE name = 'databases')),

((SELECT post_id FROM post WHERE title = 'Visualizing Neural Network Activations'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Visualizing Neural Network Activations'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Visualizing Neural Network Activations'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),
((SELECT post_id FROM post WHERE title = 'Visualizing Neural Network Activations'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'End-to-End ML Pipeline — From CSV to Deployed API'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'End-to-End ML Pipeline — From CSV to Deployed API'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'End-to-End ML Pipeline — From CSV to Deployed API'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'End-to-End ML Pipeline — From CSV to Deployed API'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'End-to-End ML Pipeline — From CSV to Deployed API'), (SELECT tag_id FROM tag WHERE name = 'ai'));


-- ------------------------------------------------------------
-- FullStack_Dev (12 posts)
-- Members: carlos_v, alex_m92, ethan_rc, kevin_nb, laura_fd, miguel_cr, tyler_mc
-- Primary tags: fullstack, react, springboot
-- Cross-topic: java, webdev, databases, python
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'carlos_v'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Full-Stack Project Architecture — What Works and What Doesn''t',
  'After two semesters of full-stack projects I''ve landed on: React + TypeScript frontend, Spring Boot REST API, MySQL. Avoid mixing frameworks early on — it costs you more time than it saves.',
  28, 13, NOW() - INTERVAL 31 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'JWT Auth Flow — Frontend to Backend Explained',
  'Spent this week wiring up JWT authentication end-to-end. On the React side you store the token in memory (not localStorage), attach it as a Bearer header, and refresh on 401. On the Spring Boot side the filter chain handles the rest.',
  35, 18, NOW() - INTERVAL 28 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ethan_rc'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Deploying Spring Boot + React on a Free Tier VPS',
  'Got our full-stack app deployed on a free Oracle Cloud instance. Spring Boot runs as a systemd service, React builds to static files served by Nginx. Here''s the full deployment checklist.',
  22, 10, NOW() - INTERVAL 26 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Global Error Handling in Spring Boot',
  'Used @ControllerAdvice + @ExceptionHandler to centralize all error responses. Now every API error returns a consistent JSON shape instead of Spring''s default HTML error page. Game changer for frontend devs.',
  19, 7, NOW() - INTERVAL 23 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'React Query vs useEffect for Data Fetching',
  'Switched from raw useEffect data fetching to React Query and cut our loading/error handling boilerplate in half. Built-in caching and refetch-on-focus are surprisingly useful for a CSUN project.',
  24, 11, NOW() - INTERVAL 20 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Database Migration Strategy with Flyway',
  'Integrated Flyway into our Spring Boot project to manage schema migrations. No more manually running ALTER TABLE statements and hoping teammates did the same. Highly recommend for team projects.',
  16, 5, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'tyler_mc'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Component Library Comparison — Shadcn vs MUI',
  'Evaluated both for our project. MUI is more complete but heavy; shadcn gives you copy-paste components you own and customize. For a small team project, shadcn won hands down.',
  20, 9, NOW() - INTERVAL 16 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'carlos_v'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Optimistic UI Updates — Is It Worth the Complexity?',
  'Implemented optimistic updates for our like button. The UX improvement is real but the rollback logic on error is messy. For a side project: maybe skip it. For a product demo: worth it.',
  14, 8, NOW() - INTERVAL 13 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ethan_rc'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Python Automation Scripts for Full-Stack Dev Workflow',
  'Wrote a Python script that scaffolds new Spring Boot entities with JPA annotations, generates the repository interface, and stubs out the service and controller. Saves me about 20 minutes per feature.',
  17, 6, NOW() - INTERVAL 10 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'File Upload Feature — Spring Boot + React',
  'Built a file upload endpoint in Spring Boot using MultipartFile and stored metadata in MySQL. React side uses a simple drag-and-drop with the Fetch API. Will share the full implementation.',
  21, 12, NOW() - INTERVAL 7 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Connection Pooling with HikariCP — Why It Matters',
  'Noticed our app slowing down under load testing. Turns out we were creating new DB connections on every request. HikariCP is built into Spring Boot — just configure pool size in application.properties.',
  18, 4, NOW() - INTERVAL 4 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'FullStack_Dev'),
  'Code Review Checklist for Full-Stack PRs',
  'Before merging any PR on our team: check for N+1 queries, verify DTO vs entity mapping, confirm no secrets in code, test on mobile viewport, and make sure error states are handled on the frontend.',
  26, 14, NOW() - INTERVAL 1 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'Full-Stack Project Architecture — What Works and What Doesn''t'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT post_id FROM post WHERE title = 'Full-Stack Project Architecture — What Works and What Doesn''t'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Full-Stack Project Architecture — What Works and What Doesn''t'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Full-Stack Project Architecture — What Works and What Doesn''t'), (SELECT tag_id FROM tag WHERE name = 'databases')),

((SELECT post_id FROM post WHERE title = 'JWT Auth Flow — Frontend to Backend Explained'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'JWT Auth Flow — Frontend to Backend Explained'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'JWT Auth Flow — Frontend to Backend Explained'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT post_id FROM post WHERE title = 'JWT Auth Flow — Frontend to Backend Explained'), (SELECT tag_id FROM tag WHERE name = 'java')),

((SELECT post_id FROM post WHERE title = 'Deploying Spring Boot + React on a Free Tier VPS'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT post_id FROM post WHERE title = 'Deploying Spring Boot + React on a Free Tier VPS'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Deploying Spring Boot + React on a Free Tier VPS'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Deploying Spring Boot + React on a Free Tier VPS'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Global Error Handling in Spring Boot'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Global Error Handling in Spring Boot'), (SELECT tag_id FROM tag WHERE name = 'java')),

((SELECT post_id FROM post WHERE title = 'React Query vs useEffect for Data Fetching'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'React Query vs useEffect for Data Fetching'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT post_id FROM post WHERE title = 'React Query vs useEffect for Data Fetching'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Database Migration Strategy with Flyway'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Database Migration Strategy with Flyway'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Database Migration Strategy with Flyway'), (SELECT tag_id FROM tag WHERE name = 'java')),

((SELECT post_id FROM post WHERE title = 'Component Library Comparison — Shadcn vs MUI'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Component Library Comparison — Shadcn vs MUI'), (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT post_id FROM post WHERE title = 'Component Library Comparison — Shadcn vs MUI'), (SELECT tag_id FROM tag WHERE name = 'ux')),

((SELECT post_id FROM post WHERE title = 'Optimistic UI Updates — Is It Worth the Complexity?'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Optimistic UI Updates — Is It Worth the Complexity?'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),

((SELECT post_id FROM post WHERE title = 'Python Automation Scripts for Full-Stack Dev Workflow'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Python Automation Scripts for Full-Stack Dev Workflow'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),

((SELECT post_id FROM post WHERE title = 'File Upload Feature — Spring Boot + React'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'File Upload Feature — Spring Boot + React'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'File Upload Feature — Spring Boot + React'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT post_id FROM post WHERE title = 'File Upload Feature — Spring Boot + React'), (SELECT tag_id FROM tag WHERE name = 'databases')),

((SELECT post_id FROM post WHERE title = 'Connection Pooling with HikariCP — Why It Matters'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Connection Pooling with HikariCP — Why It Matters'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'Connection Pooling with HikariCP — Why It Matters'), (SELECT tag_id FROM tag WHERE name = 'databases')),

((SELECT post_id FROM post WHERE title = 'Code Review Checklist for Full-Stack PRs'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT post_id FROM post WHERE title = 'Code Review Checklist for Full-Stack PRs'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Code Review Checklist for Full-Stack PRs'), (SELECT tag_id FROM tag WHERE name = 'springboot'));


-- ------------------------------------------------------------
-- Robotics_Club (10 posts)
-- Members: diana_wu, ivan_mk, miguel_cr, omar_hs, tyler_mc
-- Primary tags: robotics, engineering, python
-- Cross-topic: machinelearning, artificialintelligence, databases
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'diana_wu'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Robotics Club Spring Meeting — Notes and Next Steps',
  'Thanks everyone who came to the meeting. Summary: we''re targeting the regional competition in April, the arm assembly is 60% done, and we need two more people to help with the control systems code in Python.',
  12, 7, NOW() - INTERVAL 32 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ivan_mk'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'PID Controller Tuning — What Finally Worked',
  'Spent three sessions trying to tune the PID controller for our wheel speed. The trick was starting with only the P gain, getting stable, then adding I to eliminate steady-state error. Never touch D until P and I are solid.',
  19, 9, NOW() - INTERVAL 29 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Computer Vision for Obstacle Detection — OpenCV Setup',
  'Got OpenCV running on the robot''s onboard Pi. Using contour detection to identify and avoid obstacles on the course. Python implementation is straightforward — happy to share the script.',
  23, 11, NOW() - INTERVAL 26 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Sensor Fusion — Combining Ultrasonic and IMU Data',
  'Using a complementary filter to fuse data from our ultrasonic range finder and IMU. The result is much smoother than using either sensor alone. This technique is standard in aerospace control systems too.',
  15, 6, NOW() - INTERVAL 23 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'tyler_mc'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Logging Robot Telemetry to a Database',
  'Storing our robot''s runtime telemetry in a local SQLite database during test runs. Makes it way easier to replay sessions and debug weird behavior. Might migrate to MySQL for the web dashboard.',
  10, 4, NOW() - INTERVAL 20 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'diana_wu'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Reinforcement Learning for Path Planning — First Experiments',
  'Tried training a simple RL agent to navigate our test course using a simulated environment. Early results are messy but promising. The reward function design is the hardest part.',
  20, 12, NOW() - INTERVAL 17 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ivan_mk'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Mechanical Design Review — Arm Assembly Week 4',
  'Updated the arm design to reduce weight by 30% using a lattice structure in the 3D printed bracket. Load test results are attached. Next up: integrating the servo motor mounts.',
  8, 3, NOW() - INTERVAL 14 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Regional Competition Logistics — What We Need',
  'Competing in six weeks. Still need: transport van booking, safety equipment sign-off, and one more software person. If you know anyone interested in robotics software, send them our way.',
  7, 5, NOW() - INTERVAL 10 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'ROS2 vs Custom Control Loop — Which Should We Use?',
  'Debating whether to adopt ROS2 for our control stack or keep the custom Python loop we built. ROS2 has great tooling but a steep learning curve. For our timeline, sticking with custom might be smarter.',
  14, 8, NOW() - INTERVAL 6 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'tyler_mc'),
  (SELECT community_id FROM community WHERE community_name = 'Robotics_Club'),
  'Post-Competition Retrospective — Lessons Learned',
  'We placed 4th at regionals. The arm performed well; the navigation code had one critical bug that cost us points. Full write-up with root cause analysis and what we''ll fix for next year.',
  22, 10, NOW() - INTERVAL 2 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'Robotics Club Spring Meeting — Notes and Next Steps'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'Robotics Club Spring Meeting — Notes and Next Steps'), (SELECT tag_id FROM tag WHERE name = 'engineering')),
((SELECT post_id FROM post WHERE title = 'Robotics Club Spring Meeting — Notes and Next Steps'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'PID Controller Tuning — What Finally Worked'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'PID Controller Tuning — What Finally Worked'), (SELECT tag_id FROM tag WHERE name = 'engineering')),

((SELECT post_id FROM post WHERE title = 'Computer Vision for Obstacle Detection — OpenCV Setup'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Computer Vision for Obstacle Detection — OpenCV Setup'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Computer Vision for Obstacle Detection — OpenCV Setup'), (SELECT tag_id FROM tag WHERE name = 'robotics')),

((SELECT post_id FROM post WHERE title = 'Sensor Fusion — Combining Ultrasonic and IMU Data'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'Sensor Fusion — Combining Ultrasonic and IMU Data'), (SELECT tag_id FROM tag WHERE name = 'engineering')),
((SELECT post_id FROM post WHERE title = 'Sensor Fusion — Combining Ultrasonic and IMU Data'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Logging Robot Telemetry to a Database'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Logging Robot Telemetry to a Database'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'Logging Robot Telemetry to a Database'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Reinforcement Learning for Path Planning — First Experiments'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Reinforcement Learning for Path Planning — First Experiments'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Reinforcement Learning for Path Planning — First Experiments'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'Reinforcement Learning for Path Planning — First Experiments'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Mechanical Design Review — Arm Assembly Week 4'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'Mechanical Design Review — Arm Assembly Week 4'), (SELECT tag_id FROM tag WHERE name = 'engineering')),

((SELECT post_id FROM post WHERE title = 'Regional Competition Logistics — What We Need'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'Regional Competition Logistics — What We Need'), (SELECT tag_id FROM tag WHERE name = 'engineering')),

((SELECT post_id FROM post WHERE title = 'ROS2 vs Custom Control Loop — Which Should We Use?'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'ROS2 vs Custom Control Loop — Which Should We Use?'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'ROS2 vs Custom Control Loop — Which Should We Use?'), (SELECT tag_id FROM tag WHERE name = 'engineering')),

((SELECT post_id FROM post WHERE title = 'Post-Competition Retrospective — Lessons Learned'), (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT post_id FROM post WHERE title = 'Post-Competition Retrospective — Lessons Learned'), (SELECT tag_id FROM tag WHERE name = 'engineering'));


-- ------------------------------------------------------------
-- EdTech_Builders (10 posts)
-- Members: ethan_rc, laura_fd, natalie_bw, quinn_aj
-- Primary tags: edtech, webdev, react
-- Cross-topic: python, machinelearning, artificialintelligence, ux
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'ethan_rc'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Building an Adaptive Quiz App — Architecture Overview',
  'Our EdTech project adapts quiz difficulty based on user performance. Stack: React frontend, Spring Boot API, Python ML service for difficulty adjustment. The hardest part is defining what "adaptive" actually means in UX terms.',
  18, 10, NOW() - INTERVAL 30 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Accessibility in EdTech — A Non-Negotiable',
  'Built our app and then ran it through an a11y audit. Found 12 issues. Key takeaways: always use semantic HTML, add aria-labels to icon buttons, and never rely on color alone to convey state.',
  24, 9, NOW() - INTERVAL 27 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Using AI to Generate Practice Problems',
  'Integrated a language model API into our app to generate custom practice problems from any topic a student inputs. The quality is impressive — we''re now using it as a core feature, not just an experiment.',
  30, 15, NOW() - INTERVAL 24 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Gamification Mechanics That Actually Work',
  'Added streaks, badges, and a leaderboard to our EdTech app. Engagement went up 40% in user testing. The key is making rewards feel earned, not spammy. Less is more with gamification.',
  22, 11, NOW() - INTERVAL 21 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ethan_rc'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Spaced Repetition Algorithm — Implementing SM-2 in Python',
  'Implemented the SM-2 spaced repetition algorithm in Python for our flashcard feature. It schedules review intervals based on recall performance. The math is simple; the UX around it is what takes time.',
  20, 8, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'React State Management for Complex Learning Flows',
  'Managing learning session state in React got messy fast. Tried useContext, then Zustand. Zustand won for its simplicity and lack of boilerplate. If your state has more than 3 levels of nesting, reach for it.',
  16, 7, NOW() - INTERVAL 15 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'User Research for EdTech — What CSUN Students Actually Want',
  'Ran 8 user interviews with CSUN students. Top findings: they want mobile-first apps, offline mode is a deal-breaker for commuters, and they hate platforms that don''t save progress across sessions.',
  27, 13, NOW() - INTERVAL 12 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Monetization Models for EdTech Startups',
  'Research summary on EdTech monetization: freemium works best for student tools, subscription fatigue is real, and institutional licensing (school pays, students get free access) is the most scalable model for our space.',
  14, 6, NOW() - INTERVAL 9 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ethan_rc'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Progress Tracking Dashboard — React + Chart.js',
  'Built a learning analytics dashboard using Chart.js in React. Shows daily study time, topic coverage, and score trends. Students said this was their favorite feature in testing.',
  21, 9, NOW() - INTERVAL 5 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'EdTech_Builders'),
  'Offline Mode with Service Workers — Worth It?',
  'Implemented offline mode using a service worker and the Cache API. It''s a lot of complexity for a project, but for EdTech targeting commuting students it''s actually a differentiator. Documenting the approach here.',
  19, 8, NOW() - INTERVAL 2 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'Building an Adaptive Quiz App — Architecture Overview'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT post_id FROM post WHERE title = 'Building an Adaptive Quiz App — Architecture Overview'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Building an Adaptive Quiz App — Architecture Overview'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Building an Adaptive Quiz App — Architecture Overview'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Accessibility in EdTech — A Non-Negotiable'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT post_id FROM post WHERE title = 'Accessibility in EdTech — A Non-Negotiable'), (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT post_id FROM post WHERE title = 'Accessibility in EdTech — A Non-Negotiable'), (SELECT tag_id FROM tag WHERE name = 'ux')),

((SELECT post_id FROM post WHERE title = 'Using AI to Generate Practice Problems'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Using AI to Generate Practice Problems'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT post_id FROM post WHERE title = 'Using AI to Generate Practice Problems'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),

((SELECT post_id FROM post WHERE title = 'Gamification Mechanics That Actually Work'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT post_id FROM post WHERE title = 'Gamification Mechanics That Actually Work'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Gamification Mechanics That Actually Work'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Spaced Repetition Algorithm — Implementing SM-2 in Python'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Spaced Repetition Algorithm — Implementing SM-2 in Python'), (SELECT tag_id FROM tag WHERE name = 'edtech')),

((SELECT post_id FROM post WHERE title = 'React State Management for Complex Learning Flows'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'React State Management for Complex Learning Flows'), (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT post_id FROM post WHERE title = 'React State Management for Complex Learning Flows'), (SELECT tag_id FROM tag WHERE name = 'edtech')),

((SELECT post_id FROM post WHERE title = 'User Research for EdTech — What CSUN Students Actually Want'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT post_id FROM post WHERE title = 'User Research for EdTech — What CSUN Students Actually Want'), (SELECT tag_id FROM tag WHERE name = 'ux')),

((SELECT post_id FROM post WHERE title = 'Monetization Models for EdTech Startups'), (SELECT tag_id FROM tag WHERE name = 'edtech')),

((SELECT post_id FROM post WHERE title = 'Progress Tracking Dashboard — React + Chart.js'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Progress Tracking Dashboard — React + Chart.js'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT post_id FROM post WHERE title = 'Progress Tracking Dashboard — React + Chart.js'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),

((SELECT post_id FROM post WHERE title = 'Offline Mode with Service Workers — Worth It?'), (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT post_id FROM post WHERE title = 'Offline Mode with Service Workers — Worth It?'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT post_id FROM post WHERE title = 'Offline Mode with Service Workers — Worth It?'), (SELECT tag_id FROM tag WHERE name = 'react'));


-- ------------------------------------------------------------
-- UX_Design_CSUN (10 posts)
-- Members: fatima_ok, laura_fd, natalie_bw, paula_gm, quinn_aj
-- Primary tags: ux, webdev, react
-- Cross-topic: edtech, python, artificialintelligence
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'fatima_ok'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'Portfolio Review Thread — Drop Your Work Here',
  'Monthly portfolio review thread. Share a link or screenshots of your current portfolio and we''ll give honest feedback. Focus areas: hierarchy, color usage, and whether your case studies tell a clear story.',
  26, 20, NOW() - INTERVAL 31 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'Figma Auto Layout Tips That Will Save Your Sanity',
  'Auto Layout is the single most important Figma skill. Learn it deeply: fill vs hug vs fixed, resizing behavior, and nested auto layout. Your handoffs will become dramatically cleaner.',
  33, 15, NOW() - INTERVAL 28 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'Conducting User Interviews on a Student Budget',
  'You don''t need to pay for Maze or UserTesting. Recruit classmates with a Google Form, conduct sessions over Zoom, and use Otter.ai to transcribe. Full guerrilla research workflow that actually works.',
  21, 10, NOW() - INTERVAL 25 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'paula_gm'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'Dark Mode Design — More Than Just Inverting Colors',
  'Dark mode done right requires rethinking contrast ratios, shadow usage, and which colors stay readable on dark backgrounds. Share your dark mode designs and let''s critique them together.',
  18, 9, NOW() - INTERVAL 22 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'Design Challenge: Redesign the CSUN MyNorthridge Portal',
  'As a design exercise, let''s redesign MyNorthridge. The existing portal has: inconsistent navigation, no mobile layout, and information architecture that makes no sense. Post your concepts!',
  29, 18, NOW() - INTERVAL 19 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'fatima_ok'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'AI Tools in the UX Design Workflow',
  'Using AI for: generating placeholder copy, creating mood boards from text prompts, and auto-generating icon variations. These are productivity wins, not replacements for actual design thinking.',
  22, 11, NOW() - INTERVAL 16 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'Designing for Accessibility — WCAG 2.1 in Practice',
  'Broke down WCAG 2.1 AA requirements into a practical Figma checklist. Key ones students miss: 4.5:1 contrast for body text, focus states on all interactive elements, and alt text guidance for devs.',
  25, 12, NOW() - INTERVAL 13 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'paula_gm'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'From Wireframe to Prototype — Rapid Iteration Workflow',
  'My current workflow: paper sketch (5 min) → low-fi Figma wireframe (30 min) → user test with classmates → iterate → high-fi prototype. Testing at the lo-fi stage saves hours of wasted polish.',
  17, 8, NOW() - INTERVAL 10 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'Design Systems 101 — Why Every Project Needs One',
  'A design system is not just a style guide. It''s a shared language between designers and developers. Even for a class project, defining a minimal system (spacing scale, color tokens, type scale) pays off.',
  23, 10, NOW() - INTERVAL 6 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'UX_Design_CSUN'),
  'React Implementation of Your Figma Designs',
  'Tips for developers receiving Figma files: use the Inspect panel for exact values, match spacing to the design system tokens, and push back on designs that are physically impossible to implement responsively.',
  20, 9, NOW() - INTERVAL 3 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'Portfolio Review Thread — Drop Your Work Here'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Portfolio Review Thread — Drop Your Work Here'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Figma Auto Layout Tips That Will Save Your Sanity'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Figma Auto Layout Tips That Will Save Your Sanity'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Conducting User Interviews on a Student Budget'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Conducting User Interviews on a Student Budget'), (SELECT tag_id FROM tag WHERE name = 'edtech')),

((SELECT post_id FROM post WHERE title = 'Dark Mode Design — More Than Just Inverting Colors'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Dark Mode Design — More Than Just Inverting Colors'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Dark Mode Design — More Than Just Inverting Colors'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Design Challenge: Redesign the CSUN MyNorthridge Portal'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Design Challenge: Redesign the CSUN MyNorthridge Portal'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'AI Tools in the UX Design Workflow'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'AI Tools in the UX Design Workflow'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'AI Tools in the UX Design Workflow'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Designing for Accessibility — WCAG 2.1 in Practice'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Designing for Accessibility — WCAG 2.1 in Practice'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'From Wireframe to Prototype — Rapid Iteration Workflow'), (SELECT tag_id FROM tag WHERE name = 'ux')),

((SELECT post_id FROM post WHERE title = 'Design Systems 101 — Why Every Project Needs One'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'Design Systems 101 — Why Every Project Needs One'), (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT post_id FROM post WHERE title = 'Design Systems 101 — Why Every Project Needs One'), (SELECT tag_id FROM tag WHERE name = 'react')),

((SELECT post_id FROM post WHERE title = 'React Implementation of Your Figma Designs'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'React Implementation of Your Figma Designs'), (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT post_id FROM post WHERE title = 'React Implementation of Your Figma Designs'), (SELECT tag_id FROM tag WHERE name = 'webdev'));


-- ------------------------------------------------------------
-- CyberSec_CTF (11 posts)
-- Members: george_lp, alex_m92, kevin_nb, omar_hs, raj_pt
-- Primary tags: cybersecurity, ctf, python
-- Cross-topic: java, databases, artificialintelligence
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'george_lp'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'CTF Team Formation — Upcoming PicoCTF',
  'PicoCTF is coming up and we need a team of 4. Current confirmed: me and raj_pt. Looking for two more — ideally someone strong in web exploitation and someone who can do forensics. Reply here.',
  17, 12, NOW() - INTERVAL 33 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'SQL Injection Write-Up — CTF Challenge Breakdown',
  'Solved a blind SQL injection challenge this week. The vulnerability was in an unsanitized username field in a Spring Boot app. Documenting the full attack chain and the fix (parameterized queries + input validation).',
  25, 11, NOW() - INTERVAL 30 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'JWT Vulnerabilities — The alg:none Attack',
  'Found a CTF challenge based on the JWT "alg:none" vulnerability where the signature verification is bypassed by changing the algorithm to none. In real Spring Boot apps, always validate the algorithm explicitly.',
  29, 14, NOW() - INTERVAL 27 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'Python Scripting for CTF Automation',
  'Wrote a Python toolkit for common CTF tasks: base64/hex decode, Caesar cipher brute-force, XOR key recovery, and HTTP request automation with requests. Happy to share on GitHub.',
  23, 9, NOW() - INTERVAL 24 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'Reverse Engineering 101 — Getting Started with Ghidra',
  'Ghidra is free, powerful, and intimidating. Walkthrough for absolute beginners: load a binary, identify main, rename variables as you understand them, and work outward from known functions.',
  21, 8, NOW() - INTERVAL 21 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'george_lp'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'Web Exploitation: XSS Attack Patterns',
  'Cross-site scripting is still one of the most common web vulnerabilities. CTF perspective: know reflected vs stored vs DOM-based XSS. Defense perspective: Content Security Policy and output encoding are your friends.',
  19, 10, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'Network Traffic Analysis with Wireshark — CTF Notes',
  'Built a reference sheet for CTF network challenges: how to filter by protocol, extract files from HTTP streams, and spot anomalous packet patterns. Will post as a PDF for the team.',
  16, 6, NOW() - INTERVAL 15 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'Securing Spring Boot APIs Against Common Attacks',
  'After learning attack patterns through CTF, here''s what every Spring Boot dev should implement: rate limiting, HTTPS enforcement, proper CORS config, input validation, and JWT algorithm pinning.',
  27, 13, NOW() - INTERVAL 12 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'AI in Cybersecurity — Threat Detection Use Cases',
  'How ML is being used in security: anomaly detection on network traffic, malware classification, phishing URL detection. As CS students, this is a strong career intersection to explore.',
  22, 11, NOW() - INTERVAL 9 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'Cryptography Fundamentals for CTF — RSA and AES',
  'Understanding the math behind RSA and AES is not optional for CTF. Post covers: RSA keypair generation, common weak key attacks (small e, common factor), and AES mode vulnerabilities (ECB mode being the classic).',
  24, 10, NOW() - INTERVAL 6 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'george_lp'),
  (SELECT community_id FROM community WHERE community_name = 'CyberSec_CTF'),
  'PicoCTF Post-Mortem — What We Solved and What Beat Us',
  'We placed in the top 15% nationally. Solved 14/20 challenges. The two we couldn''t crack were a kernel exploitation challenge and a hard crypto problem. Detailed write-ups for all 14 solved challenges coming this week.',
  31, 16, NOW() - INTERVAL 3 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'CTF Team Formation — Upcoming PicoCTF'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'CTF Team Formation — Upcoming PicoCTF'), (SELECT tag_id FROM tag WHERE name = 'ctf')),

((SELECT post_id FROM post WHERE title = 'SQL Injection Write-Up — CTF Challenge Breakdown'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'SQL Injection Write-Up — CTF Challenge Breakdown'), (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT post_id FROM post WHERE title = 'SQL Injection Write-Up — CTF Challenge Breakdown'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'SQL Injection Write-Up — CTF Challenge Breakdown'), (SELECT tag_id FROM tag WHERE name = 'java')),

((SELECT post_id FROM post WHERE title = 'JWT Vulnerabilities — The alg:none Attack'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'JWT Vulnerabilities — The alg:none Attack'), (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT post_id FROM post WHERE title = 'JWT Vulnerabilities — The alg:none Attack'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE title = 'JWT Vulnerabilities — The alg:none Attack'), (SELECT tag_id FROM tag WHERE name = 'springboot')),

((SELECT post_id FROM post WHERE title = 'Python Scripting for CTF Automation'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Python Scripting for CTF Automation'), (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT post_id FROM post WHERE title = 'Python Scripting for CTF Automation'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),

((SELECT post_id FROM post WHERE title = 'Reverse Engineering 101 — Getting Started with Ghidra'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'Reverse Engineering 101 — Getting Started with Ghidra'), (SELECT tag_id FROM tag WHERE name = 'ctf')),

((SELECT post_id FROM post WHERE title = 'Web Exploitation: XSS Attack Patterns'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'Web Exploitation: XSS Attack Patterns'), (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT post_id FROM post WHERE title = 'Web Exploitation: XSS Attack Patterns'), (SELECT tag_id FROM tag WHERE name = 'webdev')),

((SELECT post_id FROM post WHERE title = 'Network Traffic Analysis with Wireshark — CTF Notes'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'Network Traffic Analysis with Wireshark — CTF Notes'), (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT post_id FROM post WHERE title = 'Network Traffic Analysis with Wireshark — CTF Notes'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Securing Spring Boot APIs Against Common Attacks'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'Securing Spring Boot APIs Against Common Attacks'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE title = 'Securing Spring Boot APIs Against Common Attacks'), (SELECT tag_id FROM tag WHERE name = 'java')),

((SELECT post_id FROM post WHERE title = 'AI in Cybersecurity — Threat Detection Use Cases'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'AI in Cybersecurity — Threat Detection Use Cases'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'AI in Cybersecurity — Threat Detection Use Cases'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),

((SELECT post_id FROM post WHERE title = 'Cryptography Fundamentals for CTF — RSA and AES'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'Cryptography Fundamentals for CTF — RSA and AES'), (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT post_id FROM post WHERE title = 'Cryptography Fundamentals for CTF — RSA and AES'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'PicoCTF Post-Mortem — What We Solved and What Beat Us'), (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT post_id FROM post WHERE title = 'PicoCTF Post-Mortem — What We Solved and What Beat Us'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE title = 'PicoCTF Post-Mortem — What We Solved and What Beat Us'), (SELECT tag_id FROM tag WHERE name = 'python'));


-- ------------------------------------------------------------
-- PreMed_Network (9 posts)
-- Members: hannah_s9, natalie_bw, paula_gm, sofia_er
-- Primary tags: premed, mcat
-- Cross-topic: machinelearning, python, artificialintelligence, databases
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'hannah_s9'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'MCAT Study Schedule That Actually Worked for Me',
  '3-month MCAT plan that got me a 515: 3 hours daily, UWorld + Anki for content review, one full AAMC practice test per week starting week 6. The CARS section needs daily practice from day one — don''t save it.',
  34, 20, NOW() - INTERVAL 32 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'Clinical Shadowing at CSUN-Adjacent Hospitals',
  'Compiled a list of hospitals and clinics near CSUN that accept shadowing requests from pre-med students: Providence Northridge, Kaiser Panorama City, and UCLA Health Woodland Hills. Tips for cold-emailing included.',
  26, 14, NOW() - INTERVAL 29 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'paula_gm'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'Research Opportunities for CSUN Pre-Med Students',
  'Getting research experience as an undergrad at CSUN is possible. Look into: faculty research assistant positions (email professors directly), the NIH-funded BUILD PODER program, and summer REU programs at nearby institutions.',
  22, 12, NOW() - INTERVAL 26 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'AI in Medicine — What Pre-Med Students Should Know',
  'Med schools are increasingly asking about AI literacy. Key areas to understand: ML in diagnostic imaging, NLP in clinical notes, and the ethical questions around algorithmic bias in healthcare. This will come up in interviews.',
  20, 10, NOW() - INTERVAL 23 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'hannah_s9'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'Personal Statement Workshop — Share Your Drafts',
  'Starting a personal statement feedback thread. Share your draft (anonymized if you want) and we''ll give constructive feedback. Focus on: does it tell a specific story, does it answer "why medicine," is it free of clichés.',
  18, 16, NOW() - INTERVAL 20 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'MCAT CARS Section Strategy — What Works',
  'CARS is the section most pre-meds underestimate. Stop trying to remember content. It''s all about identifying the author''s argument and what''s actually supported by the passage. Daily timed practice is the only fix.',
  29, 13, NOW() - INTERVAL 17 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'paula_gm'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'Bioinformatics as a Pre-Med Elective — Is It Worth It?',
  'Took a bioinformatics elective last semester as a pre-med student. Learned Python for sequence analysis, basic ML for protein structure prediction, and database querying for genomics data. Definitely worth it for MD/PhD applicants.',
  16, 8, NOW() - INTERVAL 14 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'Managing Pre-Med Burnout — Real Talk',
  'Pre-med burnout is real and we don''t talk about it enough. Signs: you''re studying but retaining nothing, you''re avoiding socializing, and you''ve stopped doing things you enjoy. Rest is not optional — it''s part of the plan.',
  38, 22, NOW() - INTERVAL 10 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'hannah_s9'),
  (SELECT community_id FROM community WHERE community_name = 'PreMed_Network'),
  'Med School Application Timeline — What to Do Each Year',
  'Year-by-year breakdown: Freshman (GPA foundation, explore research), Sophomore (start shadowing, get a mentor), Junior (MCAT prep, finalize activities list), Senior (apply early in June, secondaries fast).',
  31, 18, NOW() - INTERVAL 5 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'MCAT Study Schedule That Actually Worked for Me'), (SELECT tag_id FROM tag WHERE name = 'mcat')),
((SELECT post_id FROM post WHERE title = 'MCAT Study Schedule That Actually Worked for Me'), (SELECT tag_id FROM tag WHERE name = 'premed')),

((SELECT post_id FROM post WHERE title = 'Clinical Shadowing at CSUN-Adjacent Hospitals'), (SELECT tag_id FROM tag WHERE name = 'premed')),

((SELECT post_id FROM post WHERE title = 'Research Opportunities for CSUN Pre-Med Students'), (SELECT tag_id FROM tag WHERE name = 'premed')),
((SELECT post_id FROM post WHERE title = 'Research Opportunities for CSUN Pre-Med Students'), (SELECT tag_id FROM tag WHERE name = 'mcat')),

((SELECT post_id FROM post WHERE title = 'AI in Medicine — What Pre-Med Students Should Know'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'AI in Medicine — What Pre-Med Students Should Know'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'AI in Medicine — What Pre-Med Students Should Know'), (SELECT tag_id FROM tag WHERE name = 'premed')),

((SELECT post_id FROM post WHERE title = 'Personal Statement Workshop — Share Your Drafts'), (SELECT tag_id FROM tag WHERE name = 'premed')),

((SELECT post_id FROM post WHERE title = 'MCAT CARS Section Strategy — What Works'), (SELECT tag_id FROM tag WHERE name = 'mcat')),
((SELECT post_id FROM post WHERE title = 'MCAT CARS Section Strategy — What Works'), (SELECT tag_id FROM tag WHERE name = 'premed')),

((SELECT post_id FROM post WHERE title = 'Bioinformatics as a Pre-Med Elective — Is It Worth It?'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Bioinformatics as a Pre-Med Elective — Is It Worth It?'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Bioinformatics as a Pre-Med Elective — Is It Worth It?'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Bioinformatics as a Pre-Med Elective — Is It Worth It?'), (SELECT tag_id FROM tag WHERE name = 'premed')),

((SELECT post_id FROM post WHERE title = 'Managing Pre-Med Burnout — Real Talk'), (SELECT tag_id FROM tag WHERE name = 'premed')),

((SELECT post_id FROM post WHERE title = 'Med School Application Timeline — What to Do Each Year'), (SELECT tag_id FROM tag WHERE name = 'premed')),
((SELECT post_id FROM post WHERE title = 'Med School Application Timeline — What to Do Each Year'), (SELECT tag_id FROM tag WHERE name = 'mcat'));


-- ------------------------------------------------------------
-- Formula_SAE (10 posts)
-- Members: ivan_mk, diana_wu, miguel_cr, omar_hs
-- Primary tags: formulasae, engineering
-- Cross-topic: python, databases, machinelearning
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'ivan_mk'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Season Kickoff — Team Roles and Goals',
  'Welcome to the new Formula SAE season. Roles are assigned (see doc), and our goal this year is to finish the car two weeks before competition for a full test period. No more last-minute all-nighters.',
  15, 10, NOW() - INTERVAL 34 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'diana_wu'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Suspension Geometry Simulation Results',
  'Ran the updated suspension geometry through our sim. The new double-wishbone front setup reduces understeer by 18% in the slow slalom. Data plots are attached. Miguel, please review the camber curve.',
  12, 7, NOW() - INTERVAL 31 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Python Data Pipeline for Lap Time Analysis',
  'Built a Python pipeline that ingests telemetry CSV files from our data logger, cleans them, and outputs lap time breakdowns by sector. Helped us identify we''re losing 0.4 seconds in the hairpin.',
  19, 8, NOW() - INTERVAL 28 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Engine Cooling System Redesign',
  'The original cooling setup was running hot under sustained load. Redesigned the radiator ducting using CFD results. New setup maintains operating temp 12°C lower at peak load. Ready for fabrication.',
  14, 6, NOW() - INTERVAL 25 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ivan_mk'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Sponsor Outreach Email Template',
  'Sharing the email template we use for sponsor outreach. Key elements: quick value prop, specific ask (money vs parts vs services), what they get (logo placement, LinkedIn mention, competition invite), and a clear CTA.',
  11, 5, NOW() - INTERVAL 22 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'diana_wu'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Aerodynamics Package — Downforce vs Drag Tradeoff',
  'Our current aero package adds 45kg of downforce at 60mph but also adds significant drag on straights. Ran the tradeoff analysis across our track layout. Net lap time improvement: 0.6 seconds. Worth keeping.',
  17, 9, NOW() - INTERVAL 19 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Telemetry Database Design',
  'Moving our telemetry storage from flat CSV files to a MySQL database. Designed the schema: sessions table, lap table, telemetry_point table with timestamp + all sensor channels. Querying is now actually fast.',
  13, 6, NOW() - INTERVAL 16 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Braking System Calibration Notes',
  'Completed front/rear brake bias calibration with the driver. Settled on 60/40 front bias for our track. The brake pedal feel with the new master cylinder is much more consistent. Next: pedal box ergonomics review.',
  10, 4, NOW() - INTERVAL 13 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ivan_mk'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'ML Model for Predictive Tire Wear',
  'Trained a regression model on our historical telemetry to predict tire degradation based on speed, lateral G, and track temperature. Model is 80% accurate at predicting grip loss onset. Could inform pit strategy.',
  21, 11, NOW() - INTERVAL 8 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'diana_wu'),
  (SELECT community_id FROM community WHERE community_name = 'Formula_SAE'),
  'Pre-Competition Checklist — Final Prep',
  'Two weeks out. Mandatory checklist before we load: safety inspection sign-off, scrutineering docs ready, driver seat fit confirmed, all fasteners torqued and marked, and telemetry system functional end-to-end.',
  16, 8, NOW() - INTERVAL 4 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'Season Kickoff — Team Roles and Goals'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),
((SELECT post_id FROM post WHERE title = 'Season Kickoff — Team Roles and Goals'), (SELECT tag_id FROM tag WHERE name = 'engineering')),

((SELECT post_id FROM post WHERE title = 'Suspension Geometry Simulation Results'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),
((SELECT post_id FROM post WHERE title = 'Suspension Geometry Simulation Results'), (SELECT tag_id FROM tag WHERE name = 'engineering')),

((SELECT post_id FROM post WHERE title = 'Python Data Pipeline for Lap Time Analysis'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Python Data Pipeline for Lap Time Analysis'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),
((SELECT post_id FROM post WHERE title = 'Python Data Pipeline for Lap Time Analysis'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),

((SELECT post_id FROM post WHERE title = 'Engine Cooling System Redesign'), (SELECT tag_id FROM tag WHERE name = 'engineering')),
((SELECT post_id FROM post WHERE title = 'Engine Cooling System Redesign'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),

((SELECT post_id FROM post WHERE title = 'Sponsor Outreach Email Template'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),

((SELECT post_id FROM post WHERE title = 'Aerodynamics Package — Downforce vs Drag Tradeoff'), (SELECT tag_id FROM tag WHERE name = 'engineering')),
((SELECT post_id FROM post WHERE title = 'Aerodynamics Package — Downforce vs Drag Tradeoff'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),

((SELECT post_id FROM post WHERE title = 'Telemetry Database Design'), (SELECT tag_id FROM tag WHERE name = 'databases')),
((SELECT post_id FROM post WHERE title = 'Telemetry Database Design'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Telemetry Database Design'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),

((SELECT post_id FROM post WHERE title = 'Braking System Calibration Notes'), (SELECT tag_id FROM tag WHERE name = 'engineering')),
((SELECT post_id FROM post WHERE title = 'Braking System Calibration Notes'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),

((SELECT post_id FROM post WHERE title = 'ML Model for Predictive Tire Wear'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'ML Model for Predictive Tire Wear'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'ML Model for Predictive Tire Wear'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),

((SELECT post_id FROM post WHERE title = 'Pre-Competition Checklist — Final Prep'), (SELECT tag_id FROM tag WHERE name = 'formulasae')),
((SELECT post_id FROM post WHERE title = 'Pre-Competition Checklist — Final Prep'), (SELECT tag_id FROM tag WHERE name = 'engineering'));


-- ------------------------------------------------------------
-- Music_And_AI (10 posts)
-- Members: jasmine_hl, brianna_t, laura_fd, quinn_aj, sofia_er
-- Primary tags: music, artificialintelligence, machinelearning
-- Cross-topic: python, react, datavisualization
-- ------------------------------------------------------------

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
(
  (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Welcome to Music and AI — What Are You Building?',
  'Kicking off our community with an intro thread. I''m working on a music generation system using a transformer model trained on MIDI files. What''s everyone else exploring at the intersection of music and tech?',
  20, 15, NOW() - INTERVAL 33 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Emotion Classification from Audio — Project Update',
  'Updated our model to classify emotional content in audio clips across four dimensions: valence, arousal, dominance, and tension. Using a BiLSTM on MFCC features. Current test accuracy is 79%.',
  24, 12, NOW() - INTERVAL 30 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Building a React Music Player with AI Recommendations',
  'Building a web player in React where the queue is generated by a recommendation model based on your listening history. The backend is Python + FastAPI. Sharing the architecture diagram.',
  22, 11, NOW() - INTERVAL 27 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Generative AI for Composition — Tools Worth Trying',
  'Tested several AI composition tools: Magenta (open source, great for experimentation), Suno (impressive quality, less control), and MusicGen (best balance of control and output quality for research use).',
  28, 14, NOW() - INTERVAL 24 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Visualizing Music Structure — Chroma and Tempogram Plots',
  'Using librosa to generate chroma features and tempograms for audio analysis. These visualizations make song structure (verses, choruses, bridges) visible in a way that raw waveforms don''t.',
  19, 8, NOW() - INTERVAL 21 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'MIDI to Training Data — Preprocessing Pipeline',
  'Sharing our full MIDI preprocessing pipeline: parse with music21 → quantize note events → build vocabulary → encode as token sequences → split into train/val/test. The quantization step is the most critical for quality.',
  23, 10, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Dataset Sources for Music ML Research',
  'Best public music datasets for ML projects: Free Music Archive (FMA), the Million Song Dataset, NSynth (Google), GTZAN (genre classification), and MTG-Jamendo for multilabel tagging.',
  18, 7, NOW() - INTERVAL 15 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Audio Latency Challenges in Web Audio Applications',
  'Building web audio apps in React runs into latency issues. The Web Audio API has scheduling tools to help, but you have to understand the audio graph model. Documenting the patterns that actually work.',
  15, 6, NOW() - INTERVAL 11 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Can AI Compose Music with Emotional Intentionality?',
  'Philosophical question for the group: current AI music models optimize for pattern plausibility, not emotional meaning. Does that mean they can''t truly "compose" or just that we need better training objectives?',
  26, 19, NOW() - INTERVAL 7 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  (SELECT community_id FROM community WHERE community_name = 'Music_And_AI'),
  'Transformer Architecture for Music Generation — Reading Notes',
  'Notes from reading the Music Transformer paper. Key ideas: relative attention for capturing long-range musical structure, importance of position encoding for rhythm, and why standard Transformers struggle with music.',
  21, 10, NOW() - INTERVAL 2 DAY, false
);

INSERT INTO post_tag (post_id, tag_id) VALUES
((SELECT post_id FROM post WHERE title = 'Welcome to Music and AI — What Are You Building?'), (SELECT tag_id FROM tag WHERE name = 'music')),
((SELECT post_id FROM post WHERE title = 'Welcome to Music and AI — What Are You Building?'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Welcome to Music and AI — What Are You Building?'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),

((SELECT post_id FROM post WHERE title = 'Emotion Classification from Audio — Project Update'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Emotion Classification from Audio — Project Update'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Emotion Classification from Audio — Project Update'), (SELECT tag_id FROM tag WHERE name = 'music')),
((SELECT post_id FROM post WHERE title = 'Emotion Classification from Audio — Project Update'), (SELECT tag_id FROM tag WHERE name = 'ai')),

((SELECT post_id FROM post WHERE title = 'Building a React Music Player with AI Recommendations'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Building a React Music Player with AI Recommendations'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Building a React Music Player with AI Recommendations'), (SELECT tag_id FROM tag WHERE name = 'music')),
((SELECT post_id FROM post WHERE title = 'Building a React Music Player with AI Recommendations'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Generative AI for Composition — Tools Worth Trying'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Generative AI for Composition — Tools Worth Trying'), (SELECT tag_id FROM tag WHERE name = 'music')),
((SELECT post_id FROM post WHERE title = 'Generative AI for Composition — Tools Worth Trying'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),

((SELECT post_id FROM post WHERE title = 'Visualizing Music Structure — Chroma and Tempogram Plots'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),
((SELECT post_id FROM post WHERE title = 'Visualizing Music Structure — Chroma and Tempogram Plots'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'Visualizing Music Structure — Chroma and Tempogram Plots'), (SELECT tag_id FROM tag WHERE name = 'music')),

((SELECT post_id FROM post WHERE title = 'MIDI to Training Data — Preprocessing Pipeline'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'MIDI to Training Data — Preprocessing Pipeline'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE title = 'MIDI to Training Data — Preprocessing Pipeline'), (SELECT tag_id FROM tag WHERE name = 'music')),

((SELECT post_id FROM post WHERE title = 'Dataset Sources for Music ML Research'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Dataset Sources for Music ML Research'), (SELECT tag_id FROM tag WHERE name = 'music')),
((SELECT post_id FROM post WHERE title = 'Dataset Sources for Music ML Research'), (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT post_id FROM post WHERE title = 'Audio Latency Challenges in Web Audio Applications'), (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT post_id FROM post WHERE title = 'Audio Latency Challenges in Web Audio Applications'), (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT post_id FROM post WHERE title = 'Audio Latency Challenges in Web Audio Applications'), (SELECT tag_id FROM tag WHERE name = 'music')),

((SELECT post_id FROM post WHERE title = 'Can AI Compose Music with Emotional Intentionality?'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Can AI Compose Music with Emotional Intentionality?'), (SELECT tag_id FROM tag WHERE name = 'music')),

((SELECT post_id FROM post WHERE title = 'Transformer Architecture for Music Generation — Reading Notes'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE title = 'Transformer Architecture for Music Generation — Reading Notes'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE title = 'Transformer Architecture for Music Generation — Reading Notes'), (SELECT tag_id FROM tag WHERE name = 'music')),
((SELECT post_id FROM post WHERE title = 'Transformer Architecture for Music Generation — Reading Notes'), (SELECT tag_id FROM tag WHERE name = 'python'));


-- ============================================================
-- PROFILE POSTS (45) — Twitter-style, no title, no community
-- Spread across all 20 users
-- Tags: 0–3 per post, casual cross-topic
-- ============================================================

INSERT INTO post (author_id, community_id, title, content_text, like_count, comment_count, created_at, is_deleted)
VALUES
-- alex_m92 (3 posts)
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  NULL, NULL,
  'spent 4 hours debugging a NullPointerException that turned out to be a missing @Autowired annotation. this is fine.',
  45, 12, NOW() - INTERVAL 20 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  NULL, NULL,
  'just pushed JWT auth to main. feeling like an actual backend dev for once',
  38, 9, NOW() - INTERVAL 12 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'alex_m92'),
  NULL, NULL,
  'reminder: READ THE STACK TRACE. all the answers are in there. you''re just scared to look',
  52, 17, NOW() - INTERVAL 4 DAY, false
),

-- brianna_t (3 posts)
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  NULL, NULL,
  'my pandas dataframe finally loaded in under 2 seconds after I switched to polars and I actually screamed',
  41, 11, NOW() - INTERVAL 22 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  NULL, NULL,
  'data cleaning is 80% of the work and 0% of the glory. shoutout to every data scientist who''s ever manually fixed a datetime column',
  59, 22, NOW() - INTERVAL 14 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'brianna_t'),
  NULL, NULL,
  'validation accuracy plateaued at 74% for three days and then randomly jumped to 83% after I shuffled the training data. science is wild',
  33, 8, NOW() - INTERVAL 6 DAY, false
),

-- carlos_v (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'carlos_v'),
  NULL, NULL,
  'if your PR has more than 500 lines of changes you owe your reviewer an apology and an explanation',
  47, 16, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'carlos_v'),
  NULL, NULL,
  'full stack is fun until you have a bug and have no idea if it''s the frontend, backend, or database. could be all three. probably is.',
  55, 20, NOW() - INTERVAL 7 DAY, false
),

-- diana_wu (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'diana_wu'),
  NULL, NULL,
  'our robot passed the obstacle course on the first try and everyone in the lab clapped. best day this semester',
  62, 25, NOW() - INTERVAL 15 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'diana_wu'),
  NULL, NULL,
  'engineering tip: if the simulation says it works and reality disagrees, the simulation is wrong. trust the test rig.',
  44, 14, NOW() - INTERVAL 5 DAY, false
),

-- ethan_rc (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'ethan_rc'),
  NULL, NULL,
  'shipped the adaptive quiz feature today. watching students actually use something you built never gets old',
  36, 10, NOW() - INTERVAL 19 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ethan_rc'),
  NULL, NULL,
  'the best thing about building EdTech is that the users tell you exactly what''s broken and why. brutal but efficient',
  29, 8, NOW() - INTERVAL 9 DAY, false
),

-- fatima_ok (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'fatima_ok'),
  NULL, NULL,
  'redesigned the onboarding flow from scratch based on 6 user tests and cut task completion time by half. data-driven design works',
  48, 15, NOW() - INTERVAL 21 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'fatima_ok'),
  NULL, NULL,
  'reminder that "it looks good" is not a design critique. what problem does it solve and for whom',
  57, 21, NOW() - INTERVAL 8 DAY, false
),

-- george_lp (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'george_lp'),
  NULL, NULL,
  'CTF prep tip: learn to read hex dumps. once you can do that, forensics challenges become a lot less scary',
  34, 9, NOW() - INTERVAL 23 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'george_lp'),
  NULL, NULL,
  'every developer should do at least one CTF. nothing teaches you how your code can be broken like trying to break someone else''s',
  61, 24, NOW() - INTERVAL 11 DAY, false
),

-- hannah_s9 (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'hannah_s9'),
  NULL, NULL,
  'MCAT in 6 weeks. entering my "no social media, just Anki" era. see you all on the other side',
  43, 13, NOW() - INTERVAL 17 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'hannah_s9'),
  NULL, NULL,
  'shadowing in the ICU today changed my perspective entirely on what medicine actually looks like. humbling.',
  66, 28, NOW() - INTERVAL 6 DAY, false
),

-- ivan_mk (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'ivan_mk'),
  NULL, NULL,
  'formula SAE is 20% engineering and 80% project management. who knew',
  37, 11, NOW() - INTERVAL 20 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'ivan_mk'),
  NULL, NULL,
  'our car ran a clean lap today. months of work and the only thing better than the time was how quiet it was on the team — everyone just watching',
  58, 22, NOW() - INTERVAL 8 DAY, false
),

-- jasmine_hl (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
  NULL, NULL,
  'AI-generated music still doesn''t move me the way a human performance does. but it''s getting uncomfortably close',
  49, 19, NOW() - INTERVAL 16 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
  NULL, NULL,
  'finished training my genre classifier. 87% accuracy. the 13% it gets wrong are the interesting ones',
  42, 13, NOW() - INTERVAL 5 DAY, false
),

-- kevin_nb (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  NULL, NULL,
  'the difference between a junior and senior dev is not knowing more syntax. it''s knowing which problems not to solve',
  73, 31, NOW() - INTERVAL 24 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'kevin_nb'),
  NULL, NULL,
  'wrote 200 lines of code today, deleted 400. net negative but the codebase is actually better. this is the way',
  65, 26, NOW() - INTERVAL 10 DAY, false
),

-- laura_fd (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  NULL, NULL,
  'finally got React Query set up properly and now I''m wondering how I ever lived without it',
  44, 14, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'laura_fd'),
  NULL, NULL,
  'UX and frontend are the same job at a startup and two completely different jobs at an enterprise. wild how that works',
  38, 12, NOW() - INTERVAL 7 DAY, false
),

-- miguel_cr (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  NULL, NULL,
  'being in 4 different communities for 3 different projects is a skill issue and a scheduling issue simultaneously',
  46, 15, NOW() - INTERVAL 21 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'miguel_cr'),
  NULL, NULL,
  'the telemetry database query that used to take 8 seconds now takes 200ms after I added one index. indexes are magic',
  54, 19, NOW() - INTERVAL 9 DAY, false
),

-- natalie_bw (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  NULL, NULL,
  'ran my first solo user research session today. the participant told me everything wrong with the app in 8 minutes. UX research is humbling',
  40, 12, NOW() - INTERVAL 22 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'natalie_bw'),
  NULL, NULL,
  'do NOT underestimate the MCAT CARS section. I thought reading comp would be my strength. I was wrong',
  35, 10, NOW() - INTERVAL 10 DAY, false
),

-- omar_hs (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  NULL, NULL,
  'the CFD simulation said the cooling duct would work. the car said otherwise. always build a prototype.',
  39, 11, NOW() - INTERVAL 19 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'omar_hs'),
  NULL, NULL,
  'cybersecurity and mechanical engineering have more in common than you''d think. both are about finding where assumptions break',
  43, 14, NOW() - INTERVAL 8 DAY, false
),

-- paula_gm (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'paula_gm'),
  NULL, NULL,
  'just got accepted to a summer bioinformatics research program. if you told me freshman year I''d be using Python and ML for biology I wouldn''t have believed you',
  67, 29, NOW() - INTERVAL 16 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'paula_gm'),
  NULL, NULL,
  'design thinking and the scientific method are basically the same loop: observe, hypothesize, test, iterate',
  41, 13, NOW() - INTERVAL 5 DAY, false
),

-- quinn_aj (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  NULL, NULL,
  'used an AI tool to generate the first draft of a UI component. spent 40 minutes editing it. still faster than writing from scratch. this is where we are.',
  50, 18, NOW() - INTERVAL 20 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'quinn_aj'),
  NULL, NULL,
  'hot take: the best thing about building EdTech is that it forces you to actually understand what you''re teaching',
  46, 16, NOW() - INTERVAL 7 DAY, false
),

-- raj_pt (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  NULL, NULL,
  'I now understand why data scientists spend 80% of their time on data prep. the model is the easy part',
  53, 20, NOW() - INTERVAL 23 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'raj_pt'),
  NULL, NULL,
  'studied algorithms for 3 hours and then got asked to reverse a string in an interview. the grind never ends.',
  61, 24, NOW() - INTERVAL 9 DAY, false
),

-- sofia_er (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  NULL, NULL,
  'pre-med + data science double track is not for the faint of heart. but every week it feels more like the right call',
  48, 17, NOW() - INTERVAL 18 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'sofia_er'),
  NULL, NULL,
  'neural net visualizations finally made backpropagation click for me. sometimes you just need to see it.',
  44, 15, NOW() - INTERVAL 6 DAY, false
),

-- tyler_mc (2 posts)
(
  (SELECT user_id FROM users WHERE username = 'tyler_mc'),
  NULL, NULL,
  'wrote unit tests for the first time. found 3 bugs in code I thought was perfect. humbling and necessary.',
  56, 21, NOW() - INTERVAL 25 DAY, false
),
(
  (SELECT user_id FROM users WHERE username = 'tyler_mc'),
  NULL, NULL,
  'robotics, full stack dev, and capstone at the same time. send coffee.',
  71, 30, NOW() - INTERVAL 3 DAY, false
);

-- Profile post tags (0–3 per post, selective)
INSERT INTO post_tag (post_id, tag_id) VALUES
-- alex_m92: NullPointerException post
((SELECT post_id FROM post WHERE content_text = 'spent 4 hours debugging a NullPointerException that turned out to be a missing @Autowired annotation. this is fine.'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE content_text = 'spent 4 hours debugging a NullPointerException that turned out to be a missing @Autowired annotation. this is fine.'), (SELECT tag_id FROM tag WHERE name = 'springboot')),

-- alex_m92: JWT auth post
((SELECT post_id FROM post WHERE content_text = 'just pushed JWT auth to main. feeling like an actual backend dev for once'), (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT post_id FROM post WHERE content_text = 'just pushed JWT auth to main. feeling like an actual backend dev for once'), (SELECT tag_id FROM tag WHERE name = 'java')),

-- brianna_t: polars post
((SELECT post_id FROM post WHERE content_text = 'my pandas dataframe finally loaded in under 2 seconds after I switched to polars and I actually screamed'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE content_text = 'my pandas dataframe finally loaded in under 2 seconds after I switched to polars and I actually screamed'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),

-- brianna_t: validation accuracy post
((SELECT post_id FROM post WHERE content_text = 'validation accuracy plateaued at 74% for three days and then randomly jumped to 83% after I shuffled the training data. science is wild'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE content_text = 'validation accuracy plateaued at 74% for three days and then randomly jumped to 83% after I shuffled the training data. science is wild'), (SELECT tag_id FROM tag WHERE name = 'python')),

-- carlos_v: full stack bug post
((SELECT post_id FROM post WHERE content_text = 'full stack is fun until you have a bug and have no idea if it''s the frontend, backend, or database. could be all three. probably is.'), (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT post_id FROM post WHERE content_text = 'full stack is fun until you have a bug and have no idea if it''s the frontend, backend, or database. could be all three. probably is.'), (SELECT tag_id FROM tag WHERE name = 'databases')),

-- diana_wu: engineering tip post
((SELECT post_id FROM post WHERE content_text = 'engineering tip: if the simulation says it works and reality disagrees, the simulation is wrong. trust the test rig.'), (SELECT tag_id FROM tag WHERE name = 'engineering')),
((SELECT post_id FROM post WHERE content_text = 'engineering tip: if the simulation says it works and reality disagrees, the simulation is wrong. trust the test rig.'), (SELECT tag_id FROM tag WHERE name = 'robotics')),

-- george_lp: CTF learning post
((SELECT post_id FROM post WHERE content_text = 'every developer should do at least one CTF. nothing teaches you how your code can be broken like trying to break someone else''s'), (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT post_id FROM post WHERE content_text = 'every developer should do at least one CTF. nothing teaches you how your code can be broken like trying to break someone else''s'), (SELECT tag_id FROM tag WHERE name = 'ctf')),

-- jasmine_hl: AI music post
((SELECT post_id FROM post WHERE content_text = 'AI-generated music still doesn''t move me the way a human performance does. but it''s getting uncomfortably close'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE content_text = 'AI-generated music still doesn''t move me the way a human performance does. but it''s getting uncomfortably close'), (SELECT tag_id FROM tag WHERE name = 'music')),

-- jasmine_hl: genre classifier post
((SELECT post_id FROM post WHERE content_text = 'finished training my genre classifier. 87% accuracy. the 13% it gets wrong are the interesting ones'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE content_text = 'finished training my genre classifier. 87% accuracy. the 13% it gets wrong are the interesting ones'), (SELECT tag_id FROM tag WHERE name = 'python')),

-- kevin_nb: junior vs senior post
((SELECT post_id FROM post WHERE content_text = 'the difference between a junior and senior dev is not knowing more syntax. it''s knowing which problems not to solve'), (SELECT tag_id FROM tag WHERE name = 'java')),

-- kevin_nb: delete code post
((SELECT post_id FROM post WHERE content_text = 'wrote 200 lines of code today, deleted 400. net negative but the codebase is actually better. this is the way'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE content_text = 'wrote 200 lines of code today, deleted 400. net negative but the codebase is actually better. this is the way'), (SELECT tag_id FROM tag WHERE name = 'springboot')),

-- miguel_cr: database index post
((SELECT post_id FROM post WHERE content_text = 'the telemetry database query that used to take 8 seconds now takes 200ms after I added one index. indexes are magic'), (SELECT tag_id FROM tag WHERE name = 'databases')),

-- paula_gm: bioinformatics post
((SELECT post_id FROM post WHERE content_text = 'just got accepted to a summer bioinformatics research program. if you told me freshman year I''d be using Python and ML for biology I wouldn''t have believed you'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT post_id FROM post WHERE content_text = 'just got accepted to a summer bioinformatics research program. if you told me freshman year I''d be using Python and ML for biology I wouldn''t have believed you'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE content_text = 'just got accepted to a summer bioinformatics research program. if you told me freshman year I''d be using Python and ML for biology I wouldn''t have believed you'), (SELECT tag_id FROM tag WHERE name = 'premed')),

-- quinn_aj: AI component post
((SELECT post_id FROM post WHERE content_text = 'used an AI tool to generate the first draft of a UI component. spent 40 minutes editing it. still faster than writing from scratch. this is where we are.'), (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT post_id FROM post WHERE content_text = 'used an AI tool to generate the first draft of a UI component. spent 40 minutes editing it. still faster than writing from scratch. this is where we are.'), (SELECT tag_id FROM tag WHERE name = 'react')),

-- raj_pt: algorithms interview post
((SELECT post_id FROM post WHERE content_text = 'studied algorithms for 3 hours and then got asked to reverse a string in an interview. the grind never ends.'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE content_text = 'studied algorithms for 3 hours and then got asked to reverse a string in an interview. the grind never ends.'), (SELECT tag_id FROM tag WHERE name = 'python')),

-- sofia_er: pre-med + data science post
((SELECT post_id FROM post WHERE content_text = 'pre-med + data science double track is not for the faint of heart. but every week it feels more like the right call'), (SELECT tag_id FROM tag WHERE name = 'premed')),
((SELECT post_id FROM post WHERE content_text = 'pre-med + data science double track is not for the faint of heart. but every week it feels more like the right call'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),

-- sofia_er: backpropagation post
((SELECT post_id FROM post WHERE content_text = 'neural net visualizations finally made backpropagation click for me. sometimes you just need to see it.'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT post_id FROM post WHERE content_text = 'neural net visualizations finally made backpropagation click for me. sometimes you just need to see it.'), (SELECT tag_id FROM tag WHERE name = 'ai')),

-- tyler_mc: unit tests post
((SELECT post_id FROM post WHERE content_text = 'wrote unit tests for the first time. found 3 bugs in code I thought was perfect. humbling and necessary.'), (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT post_id FROM post WHERE content_text = 'wrote unit tests for the first time. found 3 bugs in code I thought was perfect. humbling and necessary.'), (SELECT tag_id FROM tag WHERE name = 'springboot'));


-- ============================================================
-- Sync post_count on users (if you have that column)
-- ============================================================
-- Uncomment if your users table has a post_count column:
-- UPDATE users SET post_count = (
--     SELECT COUNT(*) FROM post
--     WHERE post.author_id = users.user_id AND post.is_deleted = false
-- );

SET SQL_SAFE_UPDATES = 1;


-- ============================================================
-- Verification Queries
-- ============================================================

-- Total post count
SELECT COUNT(*) AS total_posts FROM post;

-- Posts per community (community posts only)
SELECT c.community_name, COUNT(p.post_id) AS post_count
FROM community c
JOIN post p ON p.community_id = c.community_id
WHERE p.is_deleted = false
GROUP BY c.community_name
ORDER BY post_count DESC;

-- Profile posts count
SELECT COUNT(*) AS profile_posts FROM post WHERE community_id IS NULL AND is_deleted = false;

-- Top 10 trending tags (by post usage — foundation for trending feature)
SELECT t.name AS tag, COUNT(pt.post_id) AS usage_count
FROM tag t
JOIN post_tag pt ON t.tag_id = pt.tag_id
JOIN post p ON pt.post_id = p.post_id
WHERE p.is_deleted = false
GROUP BY t.name
ORDER BY usage_count DESC
LIMIT 10;

-- Posts per user
SELECT u.username, COUNT(p.post_id) AS post_count
FROM users u
LEFT JOIN post p ON p.author_id = u.user_id AND p.is_deleted = false
GROUP BY u.username
ORDER BY post_count DESC;

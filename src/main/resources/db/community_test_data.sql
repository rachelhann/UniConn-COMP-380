-- ============================================================
-- community_test_data.sql
-- Run AFTER users_test_data.sql
--
-- 10 Communities
-- cs_capstone (6):     alex_m92*, carlos_v, kevin_nb, miguel_cr, raj_pt, tyler_mc
-- datascience_hub (5): brianna_t*, jasmine_hl, kevin_nb, raj_pt, sofia_er
-- fullstack_dev (7):   carlos_v*, alex_m92, ethan_rc, kevin_nb, laura_fd, miguel_cr, tyler_mc
-- robotics_club (5):   diana_wu*, ivan_mk, miguel_cr, omar_hs, tyler_mc
-- edtech_builders (4): ethan_rc*, laura_fd, natalie_bw, quinn_aj
-- ux_design_csun (5):  fatima_ok*, laura_fd, natalie_bw, paula_gm, quinn_aj
-- cybersec_ctf (5):    george_lp*, alex_m92, kevin_nb, omar_hs, raj_pt
-- premed_network (4):  hannah_s9*, natalie_bw, paula_gm, sofia_er
-- formula_sae (4):     ivan_mk*, diana_wu, miguel_cr, omar_hs
-- music_and_ai (5):    jasmine_hl*, brianna_t, laura_fd, quinn_aj, sofia_er
-- ============================================================
USE uni_conn;

-- ============================================================
-- Tags
-- ============================================================
INSERT INTO tag (name) VALUES
('java'),
('python'),
('machinelearning'),
('webdev'),
('react'),
('springboot'),
('databases'),
('cybersecurity'),
('ux'),
('robotics'),
('datavisualization'),
('mcat'),
('engineering'),
('music'),
('ai'),
('fullstack'),
('ctf'),
('edtech'),
('premed'),
('formulasae');


-- ============================================================
-- Communities
-- ============================================================
INSERT INTO community (community_name, description, created_by, member_count, category, created_at, updated_at)
VALUES
('cs_capstone',
 'A space for CS seniors to collaborate on capstone projects, share resources, and get feedback.',
 (SELECT user_id FROM users WHERE username = 'alex_m92'),
 6, 'ACADEMICS', NOW(), NOW()),

('datascience_hub',
 'Discuss datasets, ML models, and data visualization. Share projects with fellow data enthusiasts.',
 (SELECT user_id FROM users WHERE username = 'brianna_t'),
 5, 'ACADEMICS', NOW(), NOW()),

('fullstack_dev',
 'For students building full-stack apps. Tips on React, Spring Boot, databases, and deployment.',
 (SELECT user_id FROM users WHERE username = 'carlos_v'),
 7, 'ACADEMICS', NOW(), NOW()),

('robotics_club',
 'Official CSUN Robotics Club community. Project updates, meeting notes, and event announcements.',
 (SELECT user_id FROM users WHERE username = 'diana_wu'),
 5, 'CAMPUS_AND_EVENTS', NOW(), NOW()),

('edtech_builders',
 'Building the future of education technology. Connect with entrepreneurs, designers, and developers.',
 (SELECT user_id FROM users WHERE username = 'ethan_rc'),
 4, 'CAREER', NOW(), NOW()),

('ux_design_csun',
 'A creative space for UX/UI designers. Portfolio reviews, Figma tips, and design challenge discussions.',
 (SELECT user_id FROM users WHERE username = 'fatima_ok'),
 5, 'ACADEMICS', NOW(), NOW()),

('cybersec_ctf',
 'CTF practice group. Write-ups, tool recommendations, and team formation for upcoming competitions.',
 (SELECT user_id FROM users WHERE username = 'george_lp'),
 5, 'ACADEMICS', NOW(), NOW()),

('premed_network',
 'For pre-med and biology students. MCAT prep, research opportunities, and shadowing experience sharing.',
 (SELECT user_id FROM users WHERE username = 'hannah_s9'),
 4, 'ACADEMICS', NOW(), NOW()),

('formula_sae',
 'CSUN Formula SAE team community. Engineering updates, sponsor outreach, and race event coordination.',
 (SELECT user_id FROM users WHERE username = 'ivan_mk'),
 4, 'CAMPUS_AND_EVENTS', NOW(), NOW()),

('music_and_ai',
 'Exploring the intersection of music technology and AI. Share tools, papers, and projects.',
 (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
 5, 'OTHER', NOW(), NOW());


-- ============================================================
-- Community Tags
-- ============================================================
INSERT INTO community_tag (community_id, tag_id) VALUES
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'),     (SELECT tag_id FROM tag WHERE name = 'java')),
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'),     (SELECT tag_id FROM tag WHERE name = 'springboot')),
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'),     (SELECT tag_id FROM tag WHERE name = 'databases')),

((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT tag_id FROM tag WHERE name = 'python')),
((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT tag_id FROM tag WHERE name = 'machinelearning')),
((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT tag_id FROM tag WHERE name = 'datavisualization')),

((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'),   (SELECT tag_id FROM tag WHERE name = 'fullstack')),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'),   (SELECT tag_id FROM tag WHERE name = 'react')),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'),   (SELECT tag_id FROM tag WHERE name = 'springboot')),

((SELECT community_id FROM community WHERE community_name = 'robotics_club'),   (SELECT tag_id FROM tag WHERE name = 'robotics')),
((SELECT community_id FROM community WHERE community_name = 'robotics_club'),   (SELECT tag_id FROM tag WHERE name = 'engineering')),
((SELECT community_id FROM community WHERE community_name = 'robotics_club'),   (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT community_id FROM community WHERE community_name = 'edtech_builders'), (SELECT tag_id FROM tag WHERE name = 'edtech')),
((SELECT community_id FROM community WHERE community_name = 'edtech_builders'), (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT community_id FROM community WHERE community_name = 'edtech_builders'), (SELECT tag_id FROM tag WHERE name = 'react')),

((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'),  (SELECT tag_id FROM tag WHERE name = 'ux')),
((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'),  (SELECT tag_id FROM tag WHERE name = 'webdev')),
((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'),  (SELECT tag_id FROM tag WHERE name = 'react')),

((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'),    (SELECT tag_id FROM tag WHERE name = 'cybersecurity')),
((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'),    (SELECT tag_id FROM tag WHERE name = 'ctf')),
((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'),    (SELECT tag_id FROM tag WHERE name = 'python')),

((SELECT community_id FROM community WHERE community_name = 'premed_network'),  (SELECT tag_id FROM tag WHERE name = 'premed')),
((SELECT community_id FROM community WHERE community_name = 'premed_network'),  (SELECT tag_id FROM tag WHERE name = 'mcat')),

((SELECT community_id FROM community WHERE community_name = 'formula_sae'),     (SELECT tag_id FROM tag WHERE name = 'formulasae')),
((SELECT community_id FROM community WHERE community_name = 'formula_sae'),     (SELECT tag_id FROM tag WHERE name = 'engineering')),

((SELECT community_id FROM community WHERE community_name = 'music_and_ai'),    (SELECT tag_id FROM tag WHERE name = 'music')),
((SELECT community_id FROM community WHERE community_name = 'music_and_ai'),    (SELECT tag_id FROM tag WHERE name = 'ai')),
((SELECT community_id FROM community WHERE community_name = 'music_and_ai'),    (SELECT tag_id FROM tag WHERE name = 'machinelearning'));


-- ============================================================
-- Community Members
-- ============================================================
INSERT INTO community_member (community_id, user_id, joined_at, role)
VALUES
-- cs_capstone: alex_m92 = ADMIN, carlos_v = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'), (SELECT user_id FROM users WHERE username = 'alex_m92'),  NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'), (SELECT user_id FROM users WHERE username = 'carlos_v'),  NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),  NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'), (SELECT user_id FROM users WHERE username = 'miguel_cr'), NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'), (SELECT user_id FROM users WHERE username = 'raj_pt'),    NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'cs_capstone'), (SELECT user_id FROM users WHERE username = 'tyler_mc'), NOW(), 'REGULAR_MEMBER'),

-- datascience_hub: brianna_t = ADMIN, jasmine_hl = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT user_id FROM users WHERE username = 'brianna_t'),  NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT user_id FROM users WHERE username = 'jasmine_hl'), NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),   NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT user_id FROM users WHERE username = 'raj_pt'),     NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'datascience_hub'), (SELECT user_id FROM users WHERE username = 'sofia_er'),   NOW(), 'REGULAR_MEMBER'),

-- fullstack_dev: carlos_v = ADMIN, alex_m92 = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'), (SELECT user_id FROM users WHERE username = 'carlos_v'),  NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'), (SELECT user_id FROM users WHERE username = 'alex_m92'),  NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'), (SELECT user_id FROM users WHERE username = 'ethan_rc'),  NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),  NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'), (SELECT user_id FROM users WHERE username = 'laura_fd'),  NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'), (SELECT user_id FROM users WHERE username = 'miguel_cr'), NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'fullstack_dev'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),  NOW(), 'REGULAR_MEMBER'),

-- robotics_club: diana_wu = ADMIN, ivan_mk = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'robotics_club'), (SELECT user_id FROM users WHERE username = 'diana_wu'),  NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'robotics_club'), (SELECT user_id FROM users WHERE username = 'ivan_mk'),   NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'robotics_club'), (SELECT user_id FROM users WHERE username = 'miguel_cr'), NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'robotics_club'), (SELECT user_id FROM users WHERE username = 'omar_hs'),   NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'robotics_club'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),  NOW(), 'REGULAR_MEMBER'),

-- edtech_builders: ethan_rc = ADMIN, laura_fd = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'edtech_builders'), (SELECT user_id FROM users WHERE username = 'ethan_rc'),   NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'edtech_builders'), (SELECT user_id FROM users WHERE username = 'laura_fd'),   NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'edtech_builders'), (SELECT user_id FROM users WHERE username = 'natalie_bw'), NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'edtech_builders'), (SELECT user_id FROM users WHERE username = 'quinn_aj'),   NOW(), 'REGULAR_MEMBER'),

-- ux_design_csun: fatima_ok = ADMIN, laura_fd = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'), (SELECT user_id FROM users WHERE username = 'fatima_ok'),  NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'), (SELECT user_id FROM users WHERE username = 'laura_fd'),   NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'), (SELECT user_id FROM users WHERE username = 'natalie_bw'), NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'), (SELECT user_id FROM users WHERE username = 'paula_gm'),   NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'ux_design_csun'), (SELECT user_id FROM users WHERE username = 'quinn_aj'),   NOW(), 'REGULAR_MEMBER'),

-- cybersec_ctf: george_lp = ADMIN, alex_m92 = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'), (SELECT user_id FROM users WHERE username = 'george_lp'), NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'), (SELECT user_id FROM users WHERE username = 'alex_m92'),  NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),  NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'), (SELECT user_id FROM users WHERE username = 'omar_hs'),   NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'cybersec_ctf'), (SELECT user_id FROM users WHERE username = 'raj_pt'),    NOW(), 'REGULAR_MEMBER'),

-- premed_network: hannah_s9 = ADMIN, natalie_bw = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'premed_network'), (SELECT user_id FROM users WHERE username = 'hannah_s9'),  NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'premed_network'), (SELECT user_id FROM users WHERE username = 'natalie_bw'), NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'premed_network'), (SELECT user_id FROM users WHERE username = 'paula_gm'),   NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'premed_network'), (SELECT user_id FROM users WHERE username = 'sofia_er'),   NOW(), 'REGULAR_MEMBER'),

-- formula_sae: ivan_mk = ADMIN, diana_wu = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'formula_sae'), (SELECT user_id FROM users WHERE username = 'ivan_mk'),   NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'formula_sae'), (SELECT user_id FROM users WHERE username = 'diana_wu'),  NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'formula_sae'), (SELECT user_id FROM users WHERE username = 'miguel_cr'), NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'formula_sae'), (SELECT user_id FROM users WHERE username = 'omar_hs'),   NOW(), 'REGULAR_MEMBER'),

-- music_and_ai: jasmine_hl = ADMIN, brianna_t = MODERATOR
((SELECT community_id FROM community WHERE community_name = 'music_and_ai'), (SELECT user_id FROM users WHERE username = 'jasmine_hl'), NOW(), 'ADMIN'),
((SELECT community_id FROM community WHERE community_name = 'music_and_ai'), (SELECT user_id FROM users WHERE username = 'brianna_t'),  NOW(), 'MODERATOR'),
((SELECT community_id FROM community WHERE community_name = 'music_and_ai'), (SELECT user_id FROM users WHERE username = 'laura_fd'),   NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'music_and_ai'), (SELECT user_id FROM users WHERE username = 'quinn_aj'),   NOW(), 'REGULAR_MEMBER'),
((SELECT community_id FROM community WHERE community_name = 'music_and_ai'), (SELECT user_id FROM users WHERE username = 'sofia_er'),   NOW(), 'REGULAR_MEMBER');

-- ============================================================
-- Sync community_count on users
-- ============================================================
SET SQL_SAFE_UPDATES = 0;

UPDATE users SET community_count = (
    SELECT COUNT(*) FROM community_member
    WHERE community_member.user_id = users.user_id
);

SET SQL_SAFE_UPDATES = 1;

-- ============================================================
-- Verification
-- ============================================================

-- All Communities
SELECT * FROM uni_conn.community;

-- Communities with creator and category
SELECT c.community_name, u.username AS created_by, c.category, c.member_count
FROM community c
JOIN users u ON c.created_by = u.user_id
ORDER BY c.community_name;

-- Tags per community
SELECT c.community_name, t.name AS tag
FROM community_tag ct
JOIN community c ON ct.community_id = c.community_id
JOIN tag t ON ct.tag_id = t.tag_id
ORDER BY c.community_name;

-- Users and how many communities they joined
SELECT u.username, u.community_count
FROM users u
ORDER BY u.community_count DESC;

-- 20 Tags (both community and posts reference them)
SELECT * FROM uni_conn.tag;
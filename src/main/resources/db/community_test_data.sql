-- ============================================================
-- 10 Communities — using correct usernames from your database
-- Run order: 1) users_test_data.sql  2) community_test_data.sql
-- ============================================================
 USE uni_conn;
 
INSERT INTO community (community_name, description, created_by, member_count, created_at)
VALUES
('CS_Capstone',
 'A space for Computer Science seniors to collaborate on capstone projects, share resources, and get feedback.',
 (SELECT user_id FROM users WHERE username = 'alex_m92'),
 1, NOW()),
 
('DataScience_Hub',
 'Discuss datasets, ML models, and data visualization. Share projects and research with fellow data enthusiasts.',
 (SELECT user_id FROM users WHERE username = 'brianna_t'),
 1, NOW()),
 
('FullStack_Dev',
 'For students building full-stack applications. Share tips on React, Spring Boot, databases, and deployment.',
 (SELECT user_id FROM users WHERE username = 'carlos_v'),
 1, NOW()),
 
('Robotics_Club',
 'Official community for CSUN Robotics Club members. Project updates, meeting notes, and event announcements.',
 (SELECT user_id FROM users WHERE username = 'diana_wu'),
 1, NOW()),
 
('EdTech_Builders',
 'Building the future of education technology. Connect with entrepreneurs, designers, and developers.',
 (SELECT user_id FROM users WHERE username = 'ethan_rc'),
 1, NOW()),
 
('UX_Design_CSUN',
 'A creative space for UX/UI designers. Portfolio reviews, Figma tips, and design challenge discussions.',
 (SELECT user_id FROM users WHERE username = 'fatima_ok'),
 1, NOW()),
 
('CyberSec_CTF',
 'Capture The Flag practice group. Write-ups, tool recommendations, and team formation for upcoming competitions.',
 (SELECT user_id FROM users WHERE username = 'george_lp'),
 1, NOW()),
 
('PreMed_Network',
 'For pre-med and biology students. MCAT prep, research opportunities, and shadowing experience sharing.',
 (SELECT user_id FROM users WHERE username = 'hannah_s9'),
 1, NOW()),
 
('Formula_SAE',
 'CSUN Formula SAE team community. Engineering updates, sponsor outreach, and race event coordination.',
 (SELECT user_id FROM users WHERE username = 'ivan_mk'),
 1, NOW()),
 
('Music_And_AI',
 'Exploring the intersection of music technology and artificial intelligence. Share tools, papers, and projects.',
 (SELECT user_id FROM users WHERE username = 'jasmine_hl'),
 1, NOW());
 
-- ============================================================
-- Verification
-- ============================================================
SELECT c.community_name, u.username AS created_by, c.member_count, c.created_at
FROM community c
JOIN users u ON c.created_by = u.user_id
ORDER BY c.created_at DESC;
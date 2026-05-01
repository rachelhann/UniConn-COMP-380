-- =============================================================
-- post_likes_test_data.sql
-- Run AFTER posts_test_data.sql
-- INSERT IGNORE — safe to run multiple times, never duplicates
-- Post IDs start at 161 in this database
-- Community posts: 161-265, Profile posts: 266-307
-- User IDs: 2=alex_m92, 3=brianna_t, 4=carlos_v, 5=diana_wu,
--   6=ethan_rc, 7=fatima_ok, 8=george_lp, 9=hannah_s9,
--   10=ivan_mk, 11=jasmine_hl, 12=kevin_nb, 13=laura_fd,
--   14=miguel_cr, 15=natalie_bw, 16=omar_hs, 17=paula_gm,
--   18=quinn_aj, 19=raj_pt, 20=sofia_er, 21=tyler_mc
-- =============================================================

USE uni_conn;
SET SQL_SAFE_UPDATES = 0;

INSERT IGNORE INTO post_like (user_id, post_id, created_at) VALUES
-- alex_m92(2) likes java/springboot CS_Capstone posts
(2, 163, '2026-04-03 22:00:00'),
(2, 169, '2026-04-18 22:00:00'),
(2, 172, '2026-04-25 22:00:00'),
(2, 178, '2026-04-11 22:00:00'),

-- brianna_t(3) likes ML/data science posts
(3, 186, '2026-04-08 22:00:00'),
(3, 182, '2026-04-17 22:00:00'),
(3, 183, '2026-04-22 22:00:00'),
(3, 185, '2026-04-13 22:00:00'),

-- carlos_v(4) likes fullstack/react posts
(4, 184, '2026-03-29 22:00:00'),
(4, 192, '2026-04-16 22:00:00'),
(4, 185, '2026-03-31 22:00:00'),
(4, 190, '2026-04-10 22:00:00'),

-- diana_wu(5) likes robotics/engineering posts
(5, 196, '2026-04-03 22:00:00'),
(5, 201, '2026-04-18 22:00:00'),
(5, 200, '2026-04-13 22:00:00'),

-- ethan_rc(6) likes edtech/python posts
(6, 206, '2026-04-20 22:00:00'),
(6, 186, '2026-04-08 22:00:00'),
(6, 210, '2026-04-19 22:00:00'),

-- fatima_ok(7) likes UX/design posts
(7, 216, '2026-03-31 22:00:00'),
(7, 219, '2026-04-16 22:00:00'),
(7, 221, '2026-04-23 22:00:00'),

-- george_lp(8) likes cybersec posts
(8, 226, '2026-04-03 22:00:00'),
(8, 231, '2026-04-10 22:00:00'),
(8, 229, '2026-04-18 22:00:00'),

-- hannah_s9(9) likes premed posts
(9, 237, '2026-04-06 22:00:00'),
(9, 242, '2026-04-20 22:00:00'),
(9, 241, '2026-04-19 22:00:00'),

-- ivan_mk(10) likes formula/engineering posts
(10, 246, '2026-04-13 22:00:00'),
(10, 247, '2026-04-16 22:00:00'),
(10, 250, '2026-04-25 22:00:00'),

-- jasmine_hl(11) likes ML/AI posts
(11, 186, '2026-04-08 22:00:00'),
(11, 257, '2026-04-14 22:00:00'),
(11, 260, '2026-04-22 22:00:00'),
(11, 256, '2026-04-26 22:00:00'),

-- kevin_nb(12) likes java/springboot posts
(12, 161, '2026-03-29 22:00:00'),
(12, 162, '2026-03-31 22:00:00'),
(12, 186, '2026-04-08 22:00:00'),
(12, 172, '2026-04-25 22:00:00'),

-- laura_fd(13) likes fullstack posts
(13, 185, '2026-04-13 22:00:00'),
(13, 192, '2026-04-16 22:00:00'),
(13, 184, '2026-03-31 22:00:00'),

-- miguel_cr(14) likes databases/java posts
(14, 163, '2026-04-03 22:00:00'),
(14, 164, '2026-04-06 22:00:00'),
(14, 169, '2026-04-18 22:00:00'),
(14, 170, '2026-04-20 22:00:00'),

-- natalie_bw(15) likes edtech posts
(15, 186, '2026-04-08 22:00:00'),
(15, 190, '2026-04-10 22:00:00'),
(15, 210, '2026-04-19 22:00:00'),

-- omar_hs(16) likes cybersec posts
(16, 228, '2026-04-13 22:00:00'),
(16, 229, '2026-04-18 22:00:00'),
(16, 226, '2026-04-03 22:00:00'),

-- paula_gm(17) likes premed/social posts
(17, 240, '2026-04-19 22:00:00'),
(17, 244, '2026-04-22 22:00:00'),
(17, 243, '2026-04-17 22:00:00'),

-- quinn_aj(18) likes UX/edtech posts
(18, 221, '2026-04-23 22:00:00'),
(18, 219, '2026-04-16 22:00:00'),
(18, 214, '2026-04-10 22:00:00'),

-- raj_pt(19) likes python/ML posts
(19, 257, '2026-04-14 22:00:00'),
(19, 258, '2026-04-17 22:00:00'),
(19, 260, '2026-04-22 22:00:00'),
(19, 186, '2026-04-08 22:00:00'),

-- sofia_er(20) likes data science posts
(20, 173, '2026-03-29 22:00:00'),
(20, 178, '2026-04-11 22:00:00'),
(20, 183, '2026-04-26 22:00:00'),
(20, 182, '2026-04-17 22:00:00'),

-- tyler_mc(21) likes java/springboot posts
(21, 161, '2026-03-29 22:00:00'),
(21, 163, '2026-04-03 22:00:00'),
(21, 190, '2026-04-10 22:00:00'),
(21, 169, '2026-04-18 22:00:00');

-- Update like_count on posts to match
UPDATE post SET like_count = (
    SELECT COUNT(*) FROM post_like WHERE post_id = post.post_id
);

SET SQL_SAFE_UPDATES = 1;

-- Verify
SELECT COUNT(*) AS total_likes FROM post_like;
SELECT post_id, like_count FROM post WHERE post_id IN (161, 163, 169, 172, 186) ORDER BY post_id;

-- =============================================================
-- user_follows_test_data.sql
-- Run AFTER users_test_data.sql
-- INSERT IGNORE — safe to run multiple times, never duplicates
-- Actual user IDs in this database:
--   1=solarbit, 2=alex_m92, 3=brianna_t, 4=carlos_v,
--   5=diana_wu, 6=ethan_rc, 7=fatima_ok, 8=george_lp,
--   9=hannah_s9, 10=ivan_mk, 11=jasmine_hl, 12=kevin_nb,
--   13=laura_fd, 14=miguel_cr, 15=natalie_bw, 16=omar_hs,
--   17=paula_gm, 18=quinn_aj, 19=raj_pt, 20=sofia_er, 21=tyler_mc
-- =============================================================

USE uni_conn;
SET SQL_SAFE_UPDATES = 0;

INSERT IGNORE INTO user_follow (follower_id, following_id, created_at) VALUES
-- alex_m92(2) follows carlos_v(4), kevin_nb(12), tyler_mc(21), raj_pt(19)
(2, 4,  '2026-03-30 10:00:00'),
(2, 12, '2026-03-30 10:00:00'),
(2, 21, '2026-04-01 10:00:00'),
(2, 19, '2026-04-01 10:00:00'),

-- brianna_t(3) follows jasmine_hl(11), sofia_er(20), raj_pt(19)
(3, 11, '2026-03-30 10:00:00'),
(3, 20, '2026-03-30 10:00:00'),
(3, 19, '2026-04-02 10:00:00'),

-- carlos_v(4) follows alex_m92(2), tyler_mc(21), kevin_nb(12)
(4, 2,  '2026-03-30 10:00:00'),
(4, 21, '2026-03-30 10:00:00'),
(4, 12, '2026-04-01 10:00:00'),

-- diana_wu(5) follows ivan_mk(10), miguel_cr(14), omar_hs(16)
(5, 10, '2026-03-31 10:00:00'),
(5, 14, '2026-03-31 10:00:00'),
(5, 16, '2026-04-01 10:00:00'),

-- ethan_rc(6) follows laura_fd(13), natalie_bw(15), quinn_aj(18)
(6, 13, '2026-03-31 10:00:00'),
(6, 15, '2026-04-01 10:00:00'),
(6, 18, '2026-04-01 10:00:00'),

-- fatima_ok(7) follows paula_gm(17), quinn_aj(18), natalie_bw(15)
(7, 17, '2026-04-01 10:00:00'),
(7, 18, '2026-04-01 10:00:00'),
(7, 15, '2026-04-02 10:00:00'),

-- george_lp(8) follows alex_m92(2), kevin_nb(12), omar_hs(16)
(8, 2,  '2026-04-01 10:00:00'),
(8, 12, '2026-04-01 10:00:00'),
(8, 16, '2026-04-02 10:00:00'),

-- jasmine_hl(11) follows brianna_t(3), sofia_er(20), raj_pt(19)
(11, 3,  '2026-04-02 10:00:00'),
(11, 20, '2026-04-02 10:00:00'),
(11, 19, '2026-04-03 10:00:00'),

-- kevin_nb(12) follows alex_m92(2), tyler_mc(21), carlos_v(4)
(12, 2,  '2026-04-02 10:00:00'),
(12, 21, '2026-04-02 10:00:00'),
(12, 4,  '2026-04-03 10:00:00'),

-- miguel_cr(14) follows diana_wu(5), kevin_nb(12), raj_pt(19)
(14, 5,  '2026-04-03 10:00:00'),
(14, 12, '2026-04-03 10:00:00'),
(14, 19, '2026-04-04 10:00:00'),

-- raj_pt(19) follows alex_m92(2), kevin_nb(12), miguel_cr(14)
(19, 2,  '2026-04-04 10:00:00'),
(19, 12, '2026-04-04 10:00:00'),
(19, 14, '2026-04-05 10:00:00'),

-- tyler_mc(21) follows alex_m92(2), carlos_v(4), kevin_nb(12)
(21, 2,  '2026-04-04 10:00:00'),
(21, 4,  '2026-04-04 10:00:00'),
(21, 12, '2026-04-05 10:00:00');

-- Update follower/following counts
UPDATE users SET following_count = (
    SELECT COUNT(*) FROM user_follow WHERE follower_id = users.user_id
);
UPDATE users SET follower_count = (
    SELECT COUNT(*) FROM user_follow WHERE following_id = users.user_id
);

SET SQL_SAFE_UPDATES = 1;

-- Verify
SELECT COUNT(*) AS total_follows FROM user_follow;
SELECT user_id, username, follower_count, following_count
FROM users WHERE user_id IN (2, 3, 4, 12, 19, 21);

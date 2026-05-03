-- =============================================================
-- user_follows_test_data.sql
-- Adds follow relationships so ALL users have between 1-15
-- followers and following counts.
-- Uses INSERT IGNORE — safe to run multiple times, no duplicates
-- Built around existing 37 follow relationships already in DB
-- Existing follows preserved — only NEW pairs added here
-- =============================================================

USE uni_conn;
SET SQL_SAFE_UPDATES = 0;

INSERT IGNORE INTO user_follow (follower_id, following_id, created_at) VALUES

-- solarbit (1) — currently 0 followers, 0 following
-- Give solarbit 3 following and get 4 followers
(1, 2,  '2026-04-01 10:00:00'),  -- solarbit follows alex_m92
(1, 12, '2026-04-01 10:00:00'),  -- solarbit follows kevin_nb
(1, 19, '2026-04-01 10:00:00'),  -- solarbit follows raj_pt
(3, 1,  '2026-04-02 10:00:00'),  -- brianna_t follows solarbit
(6, 1,  '2026-04-02 10:00:00'),  -- ethan_rc follows solarbit
(9, 1,  '2026-04-02 10:00:00'),  -- hannah_s9 follows solarbit
(15, 1, '2026-04-02 10:00:00'),  -- natalie_bw follows solarbit

-- alex_m92 (2) — currently 5 followers, 4 following — good, add 2 more following
(2, 3,  '2026-04-03 10:00:00'),  -- alex follows brianna_t
(2, 11, '2026-04-03 10:00:00'),  -- alex follows jasmine_hl

-- brianna_t (3) — currently 1 follower, 3 following — add 4 followers
(2, 3,  '2026-04-03 10:00:00'),  -- alex follows brianna (above, counted)
(4, 3,  '2026-04-03 10:00:00'),  -- carlos follows brianna
(12, 3, '2026-04-03 10:00:00'),  -- kevin follows brianna
(16, 3, '2026-04-03 10:00:00'),  -- omar follows brianna

-- carlos_v (4) — currently 3 followers, 3 following — add 3 followers, 2 following
(2, 4,  '2026-04-04 10:00:00'),  -- alex follows carlos (may exist, INSERT IGNORE handles it)
(4, 6,  '2026-04-04 10:00:00'),  -- carlos follows ethan
(4, 9,  '2026-04-04 10:00:00'),  -- carlos follows hannah
(6, 4,  '2026-04-04 10:00:00'),  -- ethan follows carlos
(9, 4,  '2026-04-04 10:00:00'),  -- hannah follows carlos
(17, 4, '2026-04-04 10:00:00'),  -- paula follows carlos

-- diana_wu (5) — currently 1 follower, 3 following — add 4 followers, 2 following
(5, 9,  '2026-04-05 10:00:00'),  -- diana follows hannah
(5, 20, '2026-04-05 10:00:00'),  -- diana follows sofia
(9, 5,  '2026-04-05 10:00:00'),  -- hannah follows diana
(13, 5, '2026-04-05 10:00:00'),  -- laura follows diana
(17, 5, '2026-04-05 10:00:00'),  -- paula follows diana
(20, 5, '2026-04-05 10:00:00'),  -- sofia follows diana

-- ethan_rc (6) — currently 0 followers, 3 following — add 5 followers, 1 following
(6, 7,  '2026-04-06 10:00:00'),  -- ethan follows fatima
(2, 6,  '2026-04-06 10:00:00'),  -- alex follows ethan
(3, 6,  '2026-04-06 10:00:00'),  -- brianna follows ethan
(13, 6, '2026-04-06 10:00:00'),  -- laura follows ethan
(15, 6, '2026-04-06 10:00:00'),  -- natalie follows ethan
(18, 6, '2026-04-06 10:00:00'),  -- quinn follows ethan

-- fatima_ok (7) — currently 0 followers, 3 following — add 5 followers, 2 following
(7, 13, '2026-04-07 10:00:00'),  -- fatima follows laura
(7, 20, '2026-04-07 10:00:00'),  -- fatima follows sofia
(4, 7,  '2026-04-07 10:00:00'),  -- carlos follows fatima
(9, 7,  '2026-04-07 10:00:00'),  -- hannah follows fatima
(13, 7, '2026-04-07 10:00:00'),  -- laura follows fatima
(17, 7, '2026-04-07 10:00:00'),  -- paula follows fatima
(20, 7, '2026-04-07 10:00:00'),  -- sofia follows fatima

-- george_lp (8) — currently 0 followers, 3 following — add 4 followers, 2 following
(8, 19, '2026-04-08 10:00:00'),  -- george follows raj
(8, 21, '2026-04-08 10:00:00'),  -- george follows tyler
(2, 8,  '2026-04-08 10:00:00'),  -- alex follows george
(4, 8,  '2026-04-08 10:00:00'),  -- carlos follows george
(16, 8, '2026-04-08 10:00:00'),  -- omar follows george
(19, 8, '2026-04-08 10:00:00'),  -- raj follows george

-- hannah_s9 (9) — currently 0 followers, 0 following — add 4 following, 4 followers
(9, 15, '2026-04-09 10:00:00'),  -- hannah follows natalie
(9, 17, '2026-04-09 10:00:00'),  -- hannah follows paula
(9, 20, '2026-04-09 10:00:00'),  -- hannah follows sofia
(9, 8,  '2026-04-09 10:00:00'),  -- hannah follows george
(3, 9,  '2026-04-09 10:00:00'),  -- brianna follows hannah
(7, 9,  '2026-04-09 10:00:00'),  -- fatima follows hannah
(15, 9, '2026-04-09 10:00:00'),  -- natalie follows hannah
(17, 9, '2026-04-09 10:00:00'),  -- paula follows hannah

-- ivan_mk (10) — currently 1 follower, 0 following — add 4 following, 4 followers
(10, 5,  '2026-04-10 10:00:00'), -- ivan follows diana
(10, 14, '2026-04-10 10:00:00'), -- ivan follows miguel
(10, 16, '2026-04-10 10:00:00'), -- ivan follows omar
(10, 21, '2026-04-10 10:00:00'), -- ivan follows tyler
(8, 10,  '2026-04-10 10:00:00'), -- george follows ivan
(16, 10, '2026-04-10 10:00:00'), -- omar follows ivan
(21, 10, '2026-04-10 10:00:00'), -- tyler follows ivan
(4, 10,  '2026-04-10 10:00:00'), -- carlos follows ivan

-- jasmine_hl (11) — currently 1 follower, 3 following — add 5 followers, 2 following
(11, 2,  '2026-04-11 10:00:00'), -- jasmine follows alex
(11, 9,  '2026-04-11 10:00:00'), -- jasmine follows hannah
(3, 11,  '2026-04-11 10:00:00'), -- brianna follows jasmine
(4, 11,  '2026-04-11 10:00:00'), -- carlos follows jasmine
(13, 11, '2026-04-11 10:00:00'), -- laura follows jasmine
(17, 11, '2026-04-11 10:00:00'), -- paula follows jasmine
(20, 11, '2026-04-11 10:00:00'), -- sofia follows jasmine

-- kevin_nb (12) — currently 6 followers, 3 following — good, add 2 following
(12, 8,  '2026-04-12 10:00:00'), -- kevin follows george
(12, 19, '2026-04-12 10:00:00'), -- kevin follows raj

-- laura_fd (13) — currently 1 follower, 0 following — add 4 following, 4 followers
(13, 3,  '2026-04-13 10:00:00'), -- laura follows brianna
(13, 9,  '2026-04-13 10:00:00'), -- laura follows hannah
(13, 18, '2026-04-13 10:00:00'), -- laura follows quinn
(13, 20, '2026-04-13 10:00:00'), -- laura follows sofia
(3, 13,  '2026-04-13 10:00:00'), -- brianna follows laura
(9, 13,  '2026-04-13 10:00:00'), -- hannah follows laura
(18, 13, '2026-04-13 10:00:00'), -- quinn follows laura
(20, 13, '2026-04-13 10:00:00'), -- sofia follows laura

-- miguel_cr (14) — currently 2 followers, 3 following — add 3 followers, 2 following
(14, 2,  '2026-04-14 10:00:00'), -- miguel follows alex
(14, 16, '2026-04-14 10:00:00'), -- miguel follows omar
(3, 14,  '2026-04-14 10:00:00'), -- brianna follows miguel
(10, 14, '2026-04-14 10:00:00'), -- ivan follows miguel (above, counted)
(20, 14, '2026-04-14 10:00:00'), -- sofia follows miguel

-- natalie_bw (15) — currently 2 followers, 0 following — add 4 following, 3 followers
(15, 3,  '2026-04-15 10:00:00'), -- natalie follows brianna
(15, 13, '2026-04-15 10:00:00'), -- natalie follows laura
(15, 17, '2026-04-15 10:00:00'), -- natalie follows paula
(15, 20, '2026-04-15 10:00:00'), -- natalie follows sofia
(3, 15,  '2026-04-15 10:00:00'), -- brianna follows natalie
(13, 15, '2026-04-15 10:00:00'), -- laura follows natalie
(20, 15, '2026-04-15 10:00:00'), -- sofia follows natalie

-- omar_hs (16) — currently 2 followers, 0 following — add 4 following, 3 followers
(16, 2,  '2026-04-16 10:00:00'), -- omar follows alex
(16, 12, '2026-04-16 10:00:00'), -- omar follows kevin
(16, 19, '2026-04-16 10:00:00'), -- omar follows raj
(16, 21, '2026-04-16 10:00:00'), -- omar follows tyler
(2, 16,  '2026-04-16 10:00:00'), -- alex follows omar
(12, 16, '2026-04-16 10:00:00'), -- kevin follows omar
(19, 16, '2026-04-16 10:00:00'), -- raj follows omar

-- paula_gm (17) — currently 1 follower, 0 following — add 4 following, 4 followers
(17, 9,  '2026-04-17 10:00:00'), -- paula follows hannah
(17, 15, '2026-04-17 10:00:00'), -- paula follows natalie
(17, 18, '2026-04-17 10:00:00'), -- paula follows quinn
(17, 20, '2026-04-17 10:00:00'), -- paula follows sofia
(3, 17,  '2026-04-17 10:00:00'), -- brianna follows paula
(9, 17,  '2026-04-17 10:00:00'), -- hannah follows paula
(15, 17, '2026-04-17 10:00:00'), -- natalie follows paula
(20, 17, '2026-04-17 10:00:00'), -- sofia follows paula

-- quinn_aj (18) — currently 2 followers, 0 following — add 4 following, 3 followers
(18, 7,  '2026-04-18 10:00:00'), -- quinn follows fatima
(18, 15, '2026-04-18 10:00:00'), -- quinn follows natalie
(18, 17, '2026-04-18 10:00:00'), -- quinn follows paula
(18, 20, '2026-04-18 10:00:00'), -- quinn follows sofia
(3, 18,  '2026-04-18 10:00:00'), -- brianna follows quinn
(7, 18,  '2026-04-18 10:00:00'), -- fatima follows quinn
(17, 18, '2026-04-18 10:00:00'), -- paula follows quinn

-- raj_pt (19) — currently 4 followers, 3 following — add 2 following, 2 followers
(19, 3,  '2026-04-19 10:00:00'), -- raj follows brianna
(19, 20, '2026-04-19 10:00:00'), -- raj follows sofia
(3, 19,  '2026-04-19 10:00:00'), -- brianna follows raj
(20, 19, '2026-04-19 10:00:00'), -- sofia follows raj

-- sofia_er (20) — currently 2 followers, 0 following — add 4 following, 4 followers
(20, 3,  '2026-04-20 10:00:00'), -- sofia follows brianna
(20, 9,  '2026-04-20 10:00:00'), -- sofia follows hannah
(20, 11, '2026-04-20 10:00:00'), -- sofia follows jasmine
(20, 18, '2026-04-20 10:00:00'), -- sofia follows quinn
(3, 20,  '2026-04-20 10:00:00'), -- brianna follows sofia
(9, 20,  '2026-04-20 10:00:00'), -- hannah follows sofia
(11, 20, '2026-04-20 10:00:00'), -- jasmine follows sofia
(18, 20, '2026-04-20 10:00:00'), -- quinn follows sofia

-- tyler_mc (21) — currently 3 followers, 3 following — add 3 following, 3 followers
(21, 6,  '2026-04-21 10:00:00'), -- tyler follows ethan
(21, 8,  '2026-04-21 10:00:00'), -- tyler follows george
(21, 19, '2026-04-21 10:00:00'), -- tyler follows raj
(3, 21,  '2026-04-21 10:00:00'), -- brianna follows tyler
(6, 21,  '2026-04-21 10:00:00'), -- ethan follows tyler
(16, 21, '2026-04-21 10:00:00'); -- omar follows tyler

-- Update follower/following counts to match actual data
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
FROM users WHERE user_id BETWEEN 1 AND 21
ORDER BY user_id;
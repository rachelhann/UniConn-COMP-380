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


-- =============================================================
-- Additional follows — new users integrated into social graph
-- Range: 5-20 following and followers per new user
-- Uses INSERT IGNORE — safe to run multiple times
-- =============================================================

INSERT IGNORE INTO user_follow (follower_id, following_id, created_at) VALUES

-- aaron_bf (CS junior, mobile dev) — 8 following, 6 followers
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'carlos_v'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'noah_wt'),     '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'rachel_bd'),   '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'marco_ds'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'owen_br'),     '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'), (SELECT user_id FROM users WHERE username = 'vince_oh'),    '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'aaron_bf'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'aaron_bf'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'tyler_mc'),  (SELECT user_id FROM users WHERE username = 'aaron_bf'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'),   (SELECT user_id FROM users WHERE username = 'aaron_bf'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'aaron_bf'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'marco_ds'),  (SELECT user_id FROM users WHERE username = 'aaron_bf'),   '2026-04-22 09:05:00'),

-- aisha_km (biomedical eng) — 7 following, 8 followers
((SELECT user_id FROM users WHERE username = 'aisha_km'), (SELECT user_id FROM users WHERE username = 'hannah_s9'),   '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'aisha_km'), (SELECT user_id FROM users WHERE username = 'paula_gm'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'aisha_km'), (SELECT user_id FROM users WHERE username = 'sofia_er'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'aisha_km'), (SELECT user_id FROM users WHERE username = 'nina_pb'),     '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'aisha_km'), (SELECT user_id FROM users WHERE username = 'tina_wr'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'aisha_km'), (SELECT user_id FROM users WHERE username = 'dana_pr'),     '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'aisha_km'), (SELECT user_id FROM users WHERE username = 'mia_jk'),      '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'hannah_s9'), (SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'paula_gm'),  (SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'sofia_er'),  (SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'nina_pb'),   (SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'natalie_bw'),(SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'mia_jk'),    (SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'dana_pr'),   (SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'tina_wr'),   (SELECT user_id FROM users WHERE username = 'aisha_km'),   '2026-04-22 09:07:00'),

-- ben_tz (software eng sophomore) — 6 following, 5 followers
((SELECT user_id FROM users WHERE username = 'ben_tz'), (SELECT user_id FROM users WHERE username = 'alex_m92'),      '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'ben_tz'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),      '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'ben_tz'), (SELECT user_id FROM users WHERE username = 'carlos_v'),      '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'ben_tz'), (SELECT user_id FROM users WHERE username = 'noah_wt'),       '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'ben_tz'), (SELECT user_id FROM users WHERE username = 'kai_nm'),        '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'ben_tz'), (SELECT user_id FROM users WHERE username = 'adam_lv'),       '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'alex_m92'),  (SELECT user_id FROM users WHERE username = 'ben_tz'),     '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'ben_tz'),     '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'),   (SELECT user_id FROM users WHERE username = 'ben_tz'),     '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'kai_nm'),    (SELECT user_id FROM users WHERE username = 'ben_tz'),     '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'adam_lv'),   (SELECT user_id FROM users WHERE username = 'ben_tz'),     '2026-04-22 09:04:00'),

-- chloe_mp (graphic design + CS) — 9 following, 7 followers
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'fatima_ok'),   '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'laura_fd'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'rosa_lf'),     '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'bella_nk'),    '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'fiona_hb'),    '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'olivia_mn'),   '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'violet_sm'),   '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'quinn_aj'),    '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'chloe_mp'), (SELECT user_id FROM users WHERE username = 'natalie_bw'),  '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'fatima_ok'), (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'laura_fd'),  (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'rosa_lf'),   (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'bella_nk'),  (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'fiona_hb'),  (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'violet_sm'), (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 09:06:00'),

-- daniel_fw (cloud + distributed systems) — 7 following, 6 followers
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'alex_m92'),   '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'carlos_v'),   '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'will_ep'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'ian_cf'),     '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'quentin_jb'), '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'alex_m92'),  (SELECT user_id FROM users WHERE username = 'daniel_fw'),  '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'daniel_fw'),  '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'will_ep'),   (SELECT user_id FROM users WHERE username = 'daniel_fw'),  '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'ian_cf'),    (SELECT user_id FROM users WHERE username = 'daniel_fw'),  '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'),  (SELECT user_id FROM users WHERE username = 'daniel_fw'),  '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'),  (SELECT user_id FROM users WHERE username = 'daniel_fw'),  '2026-04-22 09:05:00'),

-- elena_vb (math + CS, competitive programming) — 10 following, 8 followers
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'raj_pt'),      '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'igor_bk'),     '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'evan_st'),     '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'cole_wf'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'pedro_ak'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'qing_lw'),     '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'wayne_pk'),    '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'alex_m92'),    '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'), (SELECT user_id FROM users WHERE username = 'brianna_t'),   '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'igor_bk'),   (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'evan_st'),   (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'cole_wf'),   (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'),  (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'),   (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'wayne_pk'),  (SELECT user_id FROM users WHERE username = 'elena_vb'),   '2026-04-22 09:07:00'),

-- felix_oh (network security) — 8 following, 7 followers
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'george_lp'),   '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'omar_hs'),     '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'raj_pt'),      '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'oscar_tn'),    '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'umar_fh'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'mason_fp'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'xavier_dn'),   '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),    '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'george_lp'), (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'omar_hs'),   (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'oscar_tn'),  (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'),   (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'mason_fp'),  (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 09:06:00'),

-- grace_ln (AI + robotics) — 12 following, 10 followers
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'diana_wu'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'jasmine_hl'),  '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'sofia_er'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'raj_pt'),      '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'qing_lw'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'hana_yo'),     '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'scott_hw'),    '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'zoe_mc'),      '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'brianna_t'),   '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'miguel_cr'),   '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'ivan_mk'),     '2026-04-22 08:10:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'), (SELECT user_id FROM users WHERE username = 'uriel_cv'),    '2026-04-22 08:11:00'),
((SELECT user_id FROM users WHERE username = 'diana_wu'),  (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'jasmine_hl'),(SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'sofia_er'),  (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'),   (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'hana_yo'),   (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'scott_hw'),  (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'),    (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'brianna_t'), (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:08:00'),
((SELECT user_id FROM users WHERE username = 'miguel_cr'), (SELECT user_id FROM users WHERE username = 'grace_ln'),   '2026-04-22 09:09:00'),

-- hector_rm (mechanical eng + Formula SAE) — 7 following, 6 followers
((SELECT user_id FROM users WHERE username = 'hector_rm'), (SELECT user_id FROM users WHERE username = 'ivan_mk'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'hector_rm'), (SELECT user_id FROM users WHERE username = 'diana_wu'),   '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'hector_rm'), (SELECT user_id FROM users WHERE username = 'miguel_cr'),  '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'hector_rm'), (SELECT user_id FROM users WHERE username = 'omar_hs'),    '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'hector_rm'), (SELECT user_id FROM users WHERE username = 'uriel_cv'),   '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'hector_rm'), (SELECT user_id FROM users WHERE username = 'gabe_rx'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'hector_rm'), (SELECT user_id FROM users WHERE username = 'sam_ot'),     '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'ivan_mk'),   (SELECT user_id FROM users WHERE username = 'hector_rm'),  '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'diana_wu'),  (SELECT user_id FROM users WHERE username = 'hector_rm'),  '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'miguel_cr'), (SELECT user_id FROM users WHERE username = 'hector_rm'),  '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'omar_hs'),   (SELECT user_id FROM users WHERE username = 'hector_rm'),  '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'uriel_cv'),  (SELECT user_id FROM users WHERE username = 'hector_rm'),  '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'gabe_rx'),   (SELECT user_id FROM users WHERE username = 'hector_rm'),  '2026-04-22 09:05:00'),

-- iris_ct (data visualization) — 9 following, 8 followers
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'brianna_t'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'sofia_er'),     '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'raj_pt'),       '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'wayne_pk'),     '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'wendy_ct'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'sierra_nt'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'tara_nv'),      '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'nina_pb'),      '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'), (SELECT user_id FROM users WHERE username = 'qing_lw'),      '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'brianna_t'),(SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'sofia_er'), (SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),   (SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'wayne_pk'), (SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'sierra_nt'),(SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'tara_nv'),  (SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'nina_pb'),  (SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 09:07:00'),

-- james_pk (CS senior + TA) — 10 following, 12 followers
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'alex_m92'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'carlos_v'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),    '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'evan_st'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'igor_bk'),     '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'quentin_jb'),  '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'june_cl'),     '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'noah_wt'),     '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'), (SELECT user_id FROM users WHERE username = 'owen_br'),     '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'alex_m92'),  (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'tyler_mc'),  (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'evan_st'),   (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'igor_bk'),   (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'quentin_jb'),(SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'june_cl'),   (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'),   (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:08:00'),
((SELECT user_id FROM users WHERE username = 'owen_br'),   (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:09:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:10:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'),  (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 09:11:00'),

-- karen_sl (information systems) — 6 following, 5 followers
((SELECT user_id FROM users WHERE username = 'karen_sl'), (SELECT user_id FROM users WHERE username = 'laura_fd'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'karen_sl'), (SELECT user_id FROM users WHERE username = 'wayne_pk'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'karen_sl'), (SELECT user_id FROM users WHERE username = 'paige_lm'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'karen_sl'), (SELECT user_id FROM users WHERE username = 'quentin_jb'),  '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'karen_sl'), (SELECT user_id FROM users WHERE username = 'bianca_rh'),   '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'karen_sl'), (SELECT user_id FROM users WHERE username = 'carlos_v'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'laura_fd'),  (SELECT user_id FROM users WHERE username = 'karen_sl'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'wayne_pk'),  (SELECT user_id FROM users WHERE username = 'karen_sl'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'paige_lm'),  (SELECT user_id FROM users WHERE username = 'karen_sl'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'quentin_jb'),(SELECT user_id FROM users WHERE username = 'karen_sl'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'bianca_rh'), (SELECT user_id FROM users WHERE username = 'karen_sl'),   '2026-04-22 09:04:00'),

-- leo_fx (game dev) — 8 following, 6 followers
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'zach_rf'),       '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'xena_ry'),       '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'zara_fn'),       '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'carlos_v'),      '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),      '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'marco_ds'),      '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'vince_oh'),      '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'leo_fx'), (SELECT user_id FROM users WHERE username = 'deja_wm'),       '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'zach_rf'),   (SELECT user_id FROM users WHERE username = 'leo_fx'),     '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'xena_ry'),   (SELECT user_id FROM users WHERE username = 'leo_fx'),     '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'zara_fn'),   (SELECT user_id FROM users WHERE username = 'leo_fx'),     '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'leo_fx'),     '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'marco_ds'),  (SELECT user_id FROM users WHERE username = 'leo_fx'),     '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'),  (SELECT user_id FROM users WHERE username = 'leo_fx'),     '2026-04-22 09:05:00'),

-- mia_jk (pre-med + health informatics) — 7 following, 9 followers
((SELECT user_id FROM users WHERE username = 'mia_jk'), (SELECT user_id FROM users WHERE username = 'hannah_s9'),     '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'mia_jk'), (SELECT user_id FROM users WHERE username = 'natalie_bw'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'mia_jk'), (SELECT user_id FROM users WHERE username = 'paula_gm'),      '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'mia_jk'), (SELECT user_id FROM users WHERE username = 'sofia_er'),      '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'mia_jk'), (SELECT user_id FROM users WHERE username = 'tina_wr'),       '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'mia_jk'), (SELECT user_id FROM users WHERE username = 'nadia_ek'),      '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'mia_jk'), (SELECT user_id FROM users WHERE username = 'dana_pr'),       '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'hannah_s9'), (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'natalie_bw'),(SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'paula_gm'),  (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'sofia_er'),  (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'tina_wr'),   (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'nadia_ek'),  (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'dana_pr'),   (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'aisha_km'),  (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'priya_sk'),  (SELECT user_id FROM users WHERE username = 'mia_jk'),     '2026-04-22 09:08:00'),

-- noah_wt (backend engineer) — 11 following, 9 followers
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),     '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'carlos_v'),     '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'alex_m92'),     '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'quentin_jb'),   '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'owen_br'),      '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'wayne_pk'),     '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'daniel_fw'),    '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'will_ep'),      '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'ian_cf'),       '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),     '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'), (SELECT user_id FROM users WHERE username = 'raj_pt'),       '2026-04-22 08:10:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'alex_m92'),  (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'quentin_jb'),(SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'owen_br'),   (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'wayne_pk'),  (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'will_ep'),   (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'ian_cf'),    (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 09:08:00'),

-- olivia_mn (UX researcher) — 8 following, 7 followers
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'fatima_ok'),  '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'laura_fd'),   '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'natalie_bw'), '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'quinn_aj'),   '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'fiona_hb'),   '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'bella_nk'),   '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'rosa_lf'),    '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'olivia_mn'), (SELECT user_id FROM users WHERE username = 'chloe_mp'),   '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'fatima_ok'), (SELECT user_id FROM users WHERE username = 'olivia_mn'),  '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'laura_fd'),  (SELECT user_id FROM users WHERE username = 'olivia_mn'),  '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'natalie_bw'),(SELECT user_id FROM users WHERE username = 'olivia_mn'),  '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'quinn_aj'),  (SELECT user_id FROM users WHERE username = 'olivia_mn'),  '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'fiona_hb'),  (SELECT user_id FROM users WHERE username = 'olivia_mn'),  '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'bella_nk'),  (SELECT user_id FROM users WHERE username = 'olivia_mn'),  '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'rosa_lf'),   (SELECT user_id FROM users WHERE username = 'olivia_mn'),  '2026-04-22 09:06:00'),

-- pedro_ak (CS + economics, fintech) — 9 following, 7 followers
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'raj_pt'),      '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'brianna_t'),   '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'sofia_er'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'yale_bt'),     '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'wayne_pk'),    '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'qing_lw'),     '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'wendy_ct'),    '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'bianca_rh'),   '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'pedro_ak'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),    '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'pedro_ak'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'brianna_t'), (SELECT user_id FROM users WHERE username = 'pedro_ak'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'sofia_er'),  (SELECT user_id FROM users WHERE username = 'pedro_ak'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'yale_bt'),   (SELECT user_id FROM users WHERE username = 'pedro_ak'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'wayne_pk'),  (SELECT user_id FROM users WHERE username = 'pedro_ak'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'),   (SELECT user_id FROM users WHERE username = 'pedro_ak'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'),  (SELECT user_id FROM users WHERE username = 'pedro_ak'),   '2026-04-22 09:06:00'),

-- qing_lw (ML researcher) — 15 following, 14 followers
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'brianna_t'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'sofia_er'),     '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'jasmine_hl'),   '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'raj_pt'),       '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'hana_yo'),      '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'scott_hw'),     '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'grace_ln'),     '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'zoe_mc'),       '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'uma_pf'),       '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'vera_sk'),      '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'nina_pb'),      '2026-04-22 08:10:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'elena_vb'),     '2026-04-22 08:11:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'theo_bw'),      '2026-04-22 08:12:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'priya_sk'),     '2026-04-22 08:13:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),     '2026-04-22 08:14:00'),
((SELECT user_id FROM users WHERE username = 'brianna_t'), (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'sofia_er'),  (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'jasmine_hl'),(SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'hana_yo'),   (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'scott_hw'),  (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'grace_ln'),  (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'),    (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'uma_pf'),    (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:08:00'),
((SELECT user_id FROM users WHERE username = 'vera_sk'),   (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:09:00'),
((SELECT user_id FROM users WHERE username = 'nina_pb'),   (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:10:00'),
((SELECT user_id FROM users WHERE username = 'elena_vb'),  (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:11:00'),
((SELECT user_id FROM users WHERE username = 'theo_bw'),   (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:12:00'),
((SELECT user_id FROM users WHERE username = 'priya_sk'),  (SELECT user_id FROM users WHERE username = 'qing_lw'),    '2026-04-22 09:13:00'),

-- rachel_bd (software eng + rock climbing) — 10 following, 8 followers
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'carlos_v'),   '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),   '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'laura_fd'),   '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'ethan_rc'),   '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'noah_wt'),    '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'owen_br'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'aaron_bf'),   '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'james_pk'),   '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'laura_fd'),  (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'ethan_rc'),  (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'),   (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'owen_br'),   (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'aaron_bf'),  (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'),  (SELECT user_id FROM users WHERE username = 'rachel_bd'),  '2026-04-22 09:07:00'),

-- sam_ot (computer engineering, embedded) — 7 following, 6 followers
((SELECT user_id FROM users WHERE username = 'sam_ot'), (SELECT user_id FROM users WHERE username = 'ivan_mk'),       '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'sam_ot'), (SELECT user_id FROM users WHERE username = 'miguel_cr'),     '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'sam_ot'), (SELECT user_id FROM users WHERE username = 'diana_wu'),      '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'sam_ot'), (SELECT user_id FROM users WHERE username = 'ramon_gf'),      '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'sam_ot'), (SELECT user_id FROM users WHERE username = 'chris_aw'),      '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'sam_ot'), (SELECT user_id FROM users WHERE username = 'gabe_rx'),       '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'sam_ot'), (SELECT user_id FROM users WHERE username = 'uriel_cv'),      '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'ivan_mk'),   (SELECT user_id FROM users WHERE username = 'sam_ot'),     '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'miguel_cr'), (SELECT user_id FROM users WHERE username = 'sam_ot'),     '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'diana_wu'),  (SELECT user_id FROM users WHERE username = 'sam_ot'),     '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'ramon_gf'),  (SELECT user_id FROM users WHERE username = 'sam_ot'),     '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'chris_aw'),  (SELECT user_id FROM users WHERE username = 'sam_ot'),     '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'gabe_rx'),   (SELECT user_id FROM users WHERE username = 'sam_ot'),     '2026-04-22 09:05:00'),

-- umar_fh (cybersecurity + CTF) — 12 following, 10 followers
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'george_lp'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'omar_hs'),      '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'raj_pt'),       '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'felix_oh'),     '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'oscar_tn'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'mason_fp'),     '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'xavier_dn'),    '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),     '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),     '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'alex_m92'),     '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'vince_oh'),     '2026-04-22 08:10:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'), (SELECT user_id FROM users WHERE username = 'june_cl'),      '2026-04-22 08:11:00'),
((SELECT user_id FROM users WHERE username = 'george_lp'), (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'omar_hs'),   (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'),  (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'oscar_tn'),  (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'mason_fp'),  (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'tyler_mc'),  (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:08:00'),
((SELECT user_id FROM users WHERE username = 'alex_m92'),  (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 09:09:00'),

-- vince_oh (open source + hackathons) — 13 following, 11 followers
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'carlos_v'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'alex_m92'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'yusuf_ab'),    '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'owen_br'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'marco_ds'),    '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'deja_wm'),     '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'rachel_bd'),   '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'noah_wt'),     '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'james_pk'),    '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),    '2026-04-22 08:10:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'ethan_rc'),    '2026-04-22 08:11:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'), (SELECT user_id FROM users WHERE username = 'leo_fx'),      '2026-04-22 08:12:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'alex_m92'),  (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'),  (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'owen_br'),   (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'marco_ds'),  (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'deja_wm'),   (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'rachel_bd'), (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'),   (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:08:00'),
((SELECT user_id FROM users WHERE username = 'james_pk'),  (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:09:00'),
((SELECT user_id FROM users WHERE username = 'tyler_mc'),  (SELECT user_id FROM users WHERE username = 'vince_oh'),   '2026-04-22 09:10:00'),

-- wendy_ct (data engineering + cloud) — 11 following, 9 followers
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'brianna_t'),   '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'raj_pt'),      '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'will_ep'),     '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'ian_cf'),      '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'wayne_pk'),    '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'daniel_fw'),   '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'sierra_nt'),   '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'tara_nv'),     '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'iris_ct'),     '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'quentin_jb'),  '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'wendy_ct'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),    '2026-04-22 08:10:00'),
((SELECT user_id FROM users WHERE username = 'brianna_t'), (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'will_ep'),   (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'ian_cf'),    (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'wayne_pk'),  (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'sierra_nt'), (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'tara_nv'),   (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'iris_ct'),   (SELECT user_id FROM users WHERE username = 'wendy_ct'),   '2026-04-22 09:08:00'),

-- xavier_dn (security researcher + bug bounty) — 10 following, 8 followers
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'george_lp'),  '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'omar_hs'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'umar_fh'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'felix_oh'),   '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'mason_fp'),   '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'oscar_tn'),   '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'raj_pt'),     '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),   '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'tyler_mc'),   '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'xavier_dn'), (SELECT user_id FROM users WHERE username = 'alex_m92'),   '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'george_lp'), (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'omar_hs'),   (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'umar_fh'),   (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'felix_oh'),  (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'mason_fp'),  (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'oscar_tn'),  (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'xavier_dn'),  '2026-04-22 09:07:00'),

-- yusuf_ab (distributed systems + open source) — 9 following, 8 followers
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'carlos_v'),    '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'kevin_nb'),    '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'alex_m92'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'vince_oh'),    '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'owen_br'),     '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'daniel_fw'),   '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'noah_wt'),     '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'will_ep'),     '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'yusuf_ab'), (SELECT user_id FROM users WHERE username = 'quentin_jb'),  '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'carlos_v'),  (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'kevin_nb'),  (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'alex_m92'),  (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'vince_oh'),  (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'owen_br'),   (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'daniel_fw'), (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'noah_wt'),   (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'will_ep'),   (SELECT user_id FROM users WHERE username = 'yusuf_ab'),   '2026-04-22 09:07:00'),

-- zoe_mc (data science + psychology) — 11 following, 10 followers
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'brianna_t'),     '2026-04-22 08:00:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'sofia_er'),      '2026-04-22 08:01:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'jasmine_hl'),    '2026-04-22 08:02:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'raj_pt'),        '2026-04-22 08:03:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'qing_lw'),       '2026-04-22 08:04:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'nina_pb'),       '2026-04-22 08:05:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'luna_ht'),       '2026-04-22 08:06:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'uma_pf'),        '2026-04-22 08:07:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'faith_gn'),      '2026-04-22 08:08:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'theo_bw'),       '2026-04-22 08:09:00'),
((SELECT user_id FROM users WHERE username = 'zoe_mc'), (SELECT user_id FROM users WHERE username = 'vera_sk'),       '2026-04-22 08:10:00'),
((SELECT user_id FROM users WHERE username = 'brianna_t'), (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:00:00'),
((SELECT user_id FROM users WHERE username = 'sofia_er'),  (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:01:00'),
((SELECT user_id FROM users WHERE username = 'jasmine_hl'),(SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:02:00'),
((SELECT user_id FROM users WHERE username = 'raj_pt'),    (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:03:00'),
((SELECT user_id FROM users WHERE username = 'qing_lw'),   (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:04:00'),
((SELECT user_id FROM users WHERE username = 'nina_pb'),   (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:05:00'),
((SELECT user_id FROM users WHERE username = 'luna_ht'),   (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:06:00'),
((SELECT user_id FROM users WHERE username = 'uma_pf'),    (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:07:00'),
((SELECT user_id FROM users WHERE username = 'faith_gn'),  (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:08:00'),
((SELECT user_id FROM users WHERE username = 'theo_bw'),   (SELECT user_id FROM users WHERE username = 'zoe_mc'),     '2026-04-22 09:09:00');

-- Sync follower/following counts
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
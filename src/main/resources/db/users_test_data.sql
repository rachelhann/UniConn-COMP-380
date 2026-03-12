-- ============================================================
-- 20 Active Users — All Optional Fields NULL
-- Optional fields omitted: name, user_bio, profile_picture_path
-- Password for all accounts: Password123!
-- Run order: 1) users_test_data.sql  2) community_test_data.sql
-- ============================================================
USE uni_conn;

INSERT INTO users (username, name, email, password, user_bio, profile_picture_path, follower_count, following_count, community_count, is_active, created_at, updated_at)
VALUES
('alex_m92',    NULL, 'alex.morris@my.csun.edu',      '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('brianna_t',   NULL, 'brianna.thomas@my.csun.edu',   '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('carlos_v',    NULL, 'carlos.vargas@my.csun.edu',    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('diana_wu',    NULL, 'diana.wu@my.csun.edu',         '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('ethan_rc',    NULL, 'ethan.ruiz@my.csun.edu',       '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('fatima_ok',   NULL, 'fatima.okafor@my.csun.edu',    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('george_lp',   NULL, 'george.lopez@my.csun.edu',     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('hannah_s9',   NULL, 'hannah.soto@my.csun.edu',      '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('ivan_mk',     NULL, 'ivan.makarov@my.csun.edu',     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('jasmine_hl',  NULL, 'jasmine.hall@my.csun.edu',     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('kevin_nb',    NULL, 'kevin.nguyen@my.csun.edu',     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('laura_fd',    NULL, 'laura.ford@my.csun.edu',       '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('miguel_cr',   NULL, 'miguel.cruz@my.csun.edu',      '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('natalie_bw',  NULL, 'natalie.brown@my.csun.edu',    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('omar_hs',     NULL, 'omar.hassan@my.csun.edu',      '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('paula_gm',    NULL, 'paula.gomez@my.csun.edu',      '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('quinn_aj',    NULL, 'quinn.adams@my.csun.edu',      '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('raj_pt',      NULL, 'raj.patel@my.csun.edu',        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('sofia_er',    NULL, 'sofia.ernst@my.csun.edu',      '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW()),
('tyler_mc',    NULL, 'tyler.mcdonald@my.csun.edu',   '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi', NULL, NULL, 0, 0, 0, true, NOW(), NOW());

-- ============================================================
-- Verification
-- ============================================================
SELECT COUNT(*)                                   AS total_inserted  FROM users WHERE is_active = true;
SELECT COUNT(*)                                   AS all_null_bio    FROM users WHERE user_bio IS NULL;
SELECT COUNT(*)                                   AS all_null_name   FROM users WHERE name IS NULL;
SELECT COUNT(*)                                   AS all_null_pic    FROM users WHERE profile_picture_path IS NULL;
SELECT username, email, is_active, created_at     FROM users         ORDER BY created_at DESC LIMIT 20;
-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. duplicate guest primary key. Expected: pk_guest, SQLSTATE 23505.
INSERT INTO portfolio."guest" ("guest_id", "email", "full_name")
VALUES (1001, 'new.guest@example.test', 'Taylor Reed');

-- 2. duplicate guest email. Expected: uq_guest_0, SQLSTATE 23505.
INSERT INTO portfolio."guest" ("guest_id", "email", "full_name")
VALUES (1101, 'alex.morgan@example.test', 'Taylor Reed');

-- 3. null guest email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."guest" ("guest_id", "email", "full_name")
VALUES (1102, NULL, 'Taylor Reed');

-- 4. duplicate room primary key. Expected: pk_room, SQLSTATE 23505.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate", "active")
VALUES (2001, '305', 'King', 150, TRUE);

-- 5. duplicate room number. Expected: uq_room_0, SQLSTATE 23505.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate", "active")
VALUES (2101, '204', 'King', 150, TRUE);

-- 6. duplicate reservation primary key. Expected: pk_reservation, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "booked_at")
VALUES (3001, 1001, 2001, '2026-12-01', '2026-12-03', 'cancelled', '2026-10-26T18:01:00Z');

-- 7. unknown reservation guest. Expected: fk_reservation_0, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "booked_at")
VALUES (3101, 9101, 2001, '2026-12-01', '2026-12-03', 'cancelled', '2026-10-26T18:02:00Z');

-- 8. unknown reservation room. Expected: fk_reservation_1, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "booked_at")
VALUES (3102, 1001, 9201, '2026-12-01', '2026-12-03', 'cancelled', '2026-10-26T18:03:00Z');

-- 9. nonpositive room rate. Expected: room_rate_positive, SQLSTATE 23514.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate", "active")
VALUES (2102, '306', 'Queen', 0, TRUE);

-- 10. invalid reservation dates. Expected: reservation_dates_valid, SQLSTATE 23514.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "booked_at")
VALUES (3103, 1001, 2001, '2026-12-04', '2026-12-03', 'cancelled', '2026-10-26T18:04:00Z');

-- 11. duplicate confirmed room arrival. Expected: confirmed_room_arrival_unique, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "booked_at")
VALUES (3104, 1001, 2001, '2026-11-05', '2026-11-07', 'confirmed', '2026-10-26T18:05:00Z');

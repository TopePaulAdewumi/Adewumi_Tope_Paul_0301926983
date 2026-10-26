-- Fictional sample records for Hotel Reservation System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."guest" ("guest_id", "email", "full_name") VALUES (1001, 'alex.morgan@example.test', 'Alex Morgan');
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate", "active") VALUES (2001, '204', 'Queen', 129.5, TRUE);
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "booked_at") VALUES (3001, 1001, 2001, '2026-11-05', '2026-11-08', 'confirmed', '2026-10-26T18:00:00Z');
COMMIT;

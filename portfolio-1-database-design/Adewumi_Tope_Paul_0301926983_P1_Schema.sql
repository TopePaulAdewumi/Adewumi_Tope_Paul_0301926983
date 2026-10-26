-- Hotel Reservation System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."guest" (
  "guest_id" bigint NOT NULL,
  "email" text NOT NULL,
  "full_name" text NOT NULL,
  CONSTRAINT "pk_guest" PRIMARY KEY ("guest_id"),
  CONSTRAINT "uq_guest_0" UNIQUE ("email")
);
CREATE TABLE portfolio."room" (
  "room_id" bigint NOT NULL,
  "room_number" text NOT NULL,
  "room_type" text NOT NULL,
  "nightly_rate" numeric(18,2) NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_room" PRIMARY KEY ("room_id"),
  CONSTRAINT "uq_room_0" UNIQUE ("room_number")
);
CREATE TABLE portfolio."reservation" (
  "reservation_id" bigint NOT NULL,
  "guest_id" bigint NOT NULL,
  "room_id" bigint NOT NULL,
  "check_in" date NOT NULL,
  "check_out" date NOT NULL,
  "status" text NOT NULL,
  "booked_at" timestamptz NOT NULL,
  CONSTRAINT "pk_reservation" PRIMARY KEY ("reservation_id")
);
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_0" FOREIGN KEY ("guest_id") REFERENCES portfolio."guest" ("guest_id");
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_1" FOREIGN KEY ("room_id") REFERENCES portfolio."room" ("room_id");
ALTER TABLE portfolio."room" ADD CONSTRAINT "room_rate_positive" CHECK ("nightly_rate" > 0);
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "reservation_dates_valid" CHECK ("check_out" > "check_in");
CREATE UNIQUE INDEX "confirmed_room_arrival_unique" ON portfolio."reservation" ("room_id", "check_in") WHERE ("status" = 'confirmed');
COMMIT;

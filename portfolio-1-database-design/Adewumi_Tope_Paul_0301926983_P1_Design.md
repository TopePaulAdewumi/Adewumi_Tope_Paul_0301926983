# Hotel Reservation System — database design

My case study records guest, room, reservation.

## Users

- Guests booking rooms
- Reservation staff managing bookings
- Analysts reviewing synthetic booking summaries

## Main operations

- Record guests and rooms
- Create and manage room reservations
- Find rooms available for a requested date range
- Summarize confirmed bookings

## Entities

| Entity | Information stored |
| --- | --- |
| guest | Stores guest contact details. |
| room | Stores room identifiers, categories, rates, and availability status. |
| reservation | Records a guest's reservation of a room for a date range. |

## guest

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| guest_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
- Unique key: (email).

## room

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| room_id | BIGINT | PK | Yes |
| room_number | TEXT | Unique | Yes |
| room_type | TEXT |  | Yes |
| nightly_rate | NUMERIC(18,2) |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (room_number).

## reservation

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reservation_id | BIGINT | PK | Yes |
| guest_id | BIGINT | FK | Yes |
| room_id | BIGINT | FK | Yes |
| check_in | DATE |  | Yes |
| check_out | DATE |  | Yes |
| status | TEXT |  | Yes |
| booked_at | TIMESTAMPTZ |  | Yes |
- guest_id → guest.guest_id
- room_id → room.room_id

## Relationships and business rules

- Each guest email address identifies at most one guest.
- Each room number identifies at most one room.
- A room's nightly rate must be greater than zero.
- Check-out must be later than check-in.
- Every reservation references an existing guest through guest_id.
- Every reservation references an existing room through room_id.
- At most one confirmed reservation may use a room for a given check-in date; enforce a partial unique constraint on room_id and check_in where status equals confirmed.

## Assumptions

- Each entity uses a single-column ID primary key whose values are globally unique across the tables.
- A confirmed reservation is unique per room and check-in date. This deliberately simplified rule does not prevent overlaps when check-in dates differ.
- For normalization, decompose a booking sheet that repeats guest and room details into Reservation, Guest, and Room, keeping each guest's and room's facts in its own table. Reservation is the root and references one guest and one room.
- Separate benchmark plan: create 20000 synthetic reservations, run the same check-in date-window filter on baseline and B-tree-indexed copies, and compare query plans and execution-time distributions under controlled conditions. Report measurements separately.


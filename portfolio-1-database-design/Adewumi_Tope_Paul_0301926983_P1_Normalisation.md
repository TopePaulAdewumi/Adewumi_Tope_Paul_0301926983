# Hotel Reservation System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| guest_id | reservation records (list) |
| --- | --- |
| 1001 | [3001] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| reservation.reservation_id | reservation.guest_id | reservation.room_id | reservation.status | guest.guest_id | guest.email | room.room_id | room.room_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | confirmed | 1001 | alex.morgan@example.test | 2001 | 204 |

Key: reservation_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## reservation_example

| reservation.reservation_id | reservation.guest_id | reservation.room_id | reservation.status | guest.guest_id | guest.email | room.room_id | room.room_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | confirmed | 1001 | alex.morgan@example.test | 2001 | 204 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## guest

| guest_id | email | full_name |
| --- | --- | --- |
| 1001 | alex.morgan@example.test | Alex Morgan |

## room

| room_id | room_number | room_type | nightly_rate | active |
| --- | --- | --- | --- | --- |
| 2001 | 204 | Queen | 129.5 | true |

## reservation

| reservation_id | guest_id | room_id | check_in | check_out | status | booked_at |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | 2026-11-05 | 2026-11-08 | confirmed | 2026-10-26T18:00:00+00:00 |

## Dependencies

- guest: (guest_id) → email, full_name
- room: (room_id) → room_number, room_type, nightly_rate, active
- reservation: (reservation_id) → guest_id, room_id, check_in, check_out, status, booked_at

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.

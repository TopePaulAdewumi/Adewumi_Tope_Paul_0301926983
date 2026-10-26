# Hotel Reservation System — SQL queries

## 1. Show related reservation, guest, room records (up to 20).

```sql
SELECT t0."reservation_id" AS "reservation_reservation_id",
       t0."check_in" AS "reservation_check_in",
       t1."guest_id" AS "guest_guest_id",
       t1."email" AS "guest_email",
       t2."room_id" AS "room_room_id",
       t2."room_number" AS "room_room_number"
FROM portfolio."reservation" t0
JOIN portfolio."guest" t1 ON t0."guest_id" = t1."guest_id"
JOIN portfolio."room" t2 ON t0."room_id" = t2."room_id"
ORDER BY t0."reservation_id", t1."guest_id", t2."room_id"
LIMIT 20;
```

| reservation_reservation_id | reservation_check_in | guest_guest_id | guest_email | room_room_id | room_room_number |
| --- | --- | --- | --- | --- | --- |
| 3001 | 2026-11-05 | 1001 | alex.morgan@example.test | 2001 | 204 |

## 2. Find room records where room_number matches "204" (up to 20).

```sql
SELECT * FROM portfolio."room"
WHERE "room_number" IS NOT DISTINCT FROM '204'
ORDER BY "room_id"
LIMIT 20;
```

| room_id | room_number | room_type | nightly_rate | active |
| --- | --- | --- | --- | --- |
| 2001 | 204 | Queen | 129.5 | true |

## 3. Count reservation records for each guest_id (up to 20 groups).

```sql
SELECT "guest_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "guest_id"
ORDER BY record_count DESC, "guest_id" NULLS LAST
LIMIT 20;
```

| guest_id | record_count |
| --- | --- |
| 1001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.027 | 0.999, 1.759, 1.027 | Sort → Seq Scan | 112 |
| After index | 0.22 | 0.221, 0.215, 0.22 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.027 ms to 0.22 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.971..0.972 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.017..0.924 rows=20 loops=1)
Planning Time: 0.402 ms
Execution Time: 0.999 ms
```

### Before index, run 2

```text
Sort (actual time=1.722..1.724 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.024..1.651 rows=20 loops=1)
Planning Time: 0.631 ms
Execution Time: 1.759 ms
```

### Before index, run 3

```text
Sort (actual time=1..1.002 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.017..0.953 rows=20 loops=1)
Planning Time: 0.452 ms
Execution Time: 1.027 ms
```

### After index, run 1

```text
Sort (actual time=0.162..0.163 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.032..0.111 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.703 ms
Execution Time: 0.221 ms
```

### After index, run 2

```text
Sort (actual time=0.16..0.162 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.033..0.113 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.018 rows=20 loops=1)
Planning Time: 0.729 ms
Execution Time: 0.215 ms
```

### After index, run 3

```text
Sort (actual time=0.163..0.165 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.033..0.116 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.776 ms
Execution Time: 0.22 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Adewumi_Tope_Paul_0301926983_P2_Queries.sql, then Adewumi_Tope_Paul_0301926983_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Adewumi_Tope_Paul_0301926983_P2_QueryResults.png) · [Index comparison](screenshots/Adewumi_Tope_Paul_0301926983_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)


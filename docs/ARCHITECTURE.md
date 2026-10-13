# ARCHITECTURE — Queue Engine

Client (Flutter B2C/B2B) --REST--> API Gateway (JWT+rate-limit) --> queue-engine :3003
Client --WSS /queue?shopId--> WS Gateway --subscribe--> Redis pub/sub `shop:{id}:queue:update`

Redis (RAM, <10ms):
- `queue:{shopId}:{yyyymmdd}` SortedSet score=seq member=ticketId (live order)
- `queue:seq:{shopId}:{date}` INCR atomik (satu pintu online+walkin)
- `ticket:{id}` Hash detail + status
- publish `shop:{id}:queue:update` setiap take/call/start/finish

Postgres (persistent): users, barbershops(lat/lng+PostGIS GIST), subscriptions QRIS, queue_logs (analitik peak hours).
Flow B2B: CALL (masih di set, kirim reminder jika posisi<=3) -> START/SERVING (ZREM, posisi maju) -> DONE.

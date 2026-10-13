# BarberAntri — Real-time Queue + Location Discovery

Monorepo: `mobile_app/` (Flutter) + `backend_microservices/` (Node.js) + `infra/`.

## Quickstart queue-engine
```powershell
docker compose up -d redis
cd backend_microservices/services/queue_engine_service
npm install; npm test; npm run dev
# REST :3003, WS wss://host/queue?shopId=xxx
```
API: `POST /queue/take`, `POST /queue/walkin`, `POST /queue/:id/call|start|finish|cancel`, `GET /queue/:shopId`, `WS /queue?shopId=`.
Redis: `queue:{shopId}:{yyyymmdd}` SortedSet, `queue:seq:{shopId}:{date}` INCR atomik, pub/sub `shop:{id}:queue:update`.

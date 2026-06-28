.PHONY: init dev kill-ports update

BACKEND_PORT  := 3000
FRONTEND_PORT := 3001

update:
	cd frontend && pnpm install --lockfile-only
	cd backend && go get -u && go mod tidy

init: update
	cd frontend && pnpm install
	cd backend && go mod tidy
	cd backend && go build -o tmp/main .
	cd backend && tmp/main superuser upsert admin@mail.internal password --dir=pb_data
    
kill-ports:
	@lsof -ti:$(FRONTEND_PORT) | xargs -r kill -9 2>/dev/null || true
	@lsof -ti:$(BACKEND_PORT)  | xargs -r kill -9 2>/dev/null || true



dev: kill-ports
	cd backend && air &
	cd frontend && pnpm run dev





APP_NAME := my-app
BIN_DIR  := bin

BACKEND_PORT  := 3000
FRONTEND_PORT := 3001

.PHONY: init dev kill-ports update build build-frontend build-backend clean server


update:
	cd frontend && pnpm install --lockfile-only
	#cd backend && go get -u && go mod tidy

init:
	cd frontend && pnpm install
	cd backend && go mod tidy
	cd backend && go build -o tmp/main .
	cd backend && tmp/main migrate up --dir=pb_data
	cd backend && tmp/main superuser upsert admin@mail.internal password --dir=pb_data


kill-ports:
	@lsof -ti:$(FRONTEND_PORT) | xargs -r kill -9 2>/dev/null || true
	@lsof -ti:$(BACKEND_PORT)  | xargs -r kill -9 2>/dev/null || true



dev: kill-ports
	cd backend && air &
	cd frontend && pnpm run dev



#---------------------------------

# Build a single self-contained binary with the frontend embedded.
build: build-frontend build-backend

# Build the Solid.js app and copy it into backend/pb_public for embedding.
build-frontend:
	cd frontend && pnpm install && pnpm run build
	rm -rf backend/pb_public/*
	cp -r frontend/dist/. backend/pb_public/

# Compile the Go binary (frontend assets get embedded via go:embed).
build-backend:
	mkdir -p $(BIN_DIR)
	cd backend && go build -o ../$(BIN_DIR)/$(APP_NAME) .

clean:
	rm -rf $(BIN_DIR) frontend/dist
	rm -rf backend/pb_public/*
	#rm -fr backend/pb_data
	#cd backend && go clean -modcache
	#cd backend && go mod tidy

server: kill-ports build
	./bin/$(APP_NAME) superuser upsert admin@mail.internal password --dir=pb_data
	./bin/$(APP_NAME) serve --http=0.0.0.0:3000 --dir=pb_data

# pb_dataについて
# ---------------
# --dir=pb_dataは、バイナリのある場所からの相対パスになる。
#  もし、--dirで場所を指定しなければ、コマンドを実行したカレントディレクトリにpb_dataが生成される。

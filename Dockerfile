# https://docs.astral.sh/uv/guides/integration/docker/#non-editable-installs
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

WORKDIR /app

COPY uv.lock uv.lock
COPY pyproject.toml pyproject.toml

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-install-project --no-editable

COPY . /app

# Sync the project
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-editable

FROM python:3.13-slim

# Copy the environment, but not the source code
COPY --from=builder --chown=app:app /app/.venv /app/.venv
ENV FASTMCP_HOST=0.0.0.0

CMD ["/app/.venv/bin/mcp_weather_server"]

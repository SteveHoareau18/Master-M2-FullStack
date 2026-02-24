# ── Build stage ──────────────────────────────────────────────────────────────
FROM python:3.11-slim AS builder
WORKDIR /app
# Install compiler, clean apt cache in the same layer to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ── Production stage ──────────────────────────────────────────────────────────
FROM python:3.11-slim
WORKDIR /app
RUN useradd -m cloudshop
# Copy only the installed packages from builder (no compiler, no build tools)
COPY --from=builder /root/.local /home/cloudshop/.local
ENV PATH=/home/cloudshop/.local/bin:$PATH
COPY --chown=cloudshop:cloudshop . .
USER cloudshop
EXPOSE 8082

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8082/health').read()"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8082"]

# Stage 1: Build
# Utilisation de l'image slim pour réduire la surface d'attaque et la taille
FROM python:3.11-slim AS builder

WORKDIR /app

# Installation des dépendances système nécessaires à la compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Création d'un venv isolé — plus robuste que --user en contexte Docker
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copie et installation des dépendances Python dans le venv
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
# On repart d'une image vierge pour la production
FROM python:3.11-slim

WORKDIR /app

# Création d'un utilisateur non-root pour la sécurité (UID 1001)
RUN useradd -m -u 1001 appuser

# Copie du venv depuis le stage builder
COPY --from=builder /opt/venv /opt/venv

# Mise à jour du PATH pour que Python utilise les packages du venv
ENV PATH="/opt/venv/bin:$PATH"

# Copie du code source avec les bonnes permissions
COPY --chown=appuser:appuser . .

# Bascule sur l'utilisateur non-privileged
USER appuser

# Exposition du port requis
EXPOSE 8082

# Healthcheck natif en Python pour vérifier que l'API répond
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8082/health').read()"

# Démarrage de l'application avec Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8082"]
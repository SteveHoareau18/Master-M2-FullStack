#!/bin/bash

# ============================================================
# build.sh — Génère le fichier .env et lance docker-compose
# ============================================================

ENV_FILE=".env"

# --- Vérification de l'existence du .env ---
if [ -f "$ENV_FILE" ]; then
  echo "⚠️  Un fichier $ENV_FILE existe déjà."
  read -rp "Voulez-vous le régénérer ? (o/N) : " OVERWRITE
  if [[ "$OVERWRITE" != "o" && "$OVERWRITE" != "O" ]]; then
    echo "✅ Fichier $ENV_FILE conservé."
    exit 0
  fi
fi

echo ""
echo "🔧 Génération du fichier .env pour CloudShop"
echo "============================================="

# --- POSTGRES_PASSWORD ---
read -rsp "🔑 Mot de passe PostgreSQL (POSTGRES_PASSWORD) : " POSTGRES_PASSWORD
echo ""

# --- JWT_SECRET ---
read -rsp "🔐 Secret JWT (JWT_SECRET) [laisser vide pour générer automatiquement] : " JWT_SECRET
echo ""

if [ -z "$JWT_SECRET" ]; then
  JWT_SECRET=$(openssl rand -hex 32)
  echo "   → JWT_SECRET généré automatiquement."
fi

# --- DATABASE_URL ---
# Construite à partir de POSTGRES_PASSWORD pour rester cohérent
DATABASE_URL="postgresql://cloudshop:${POSTGRES_PASSWORD}@cloudshop-postgres:5432/cloudshop"

# --- Écriture du .env ---
cat > "$ENV_FILE" <<EOF
# Généré automatiquement par build.sh — $(date '+%Y-%m-%d %H:%M:%S')
# ⚠️  Ne pas committer ce fichier (ajoutez .env à votre .gitignore)

# PostgreSQL
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

# URL de connexion à la base de données
DATABASE_URL=${DATABASE_URL}

# JWT
JWT_SECRET=${JWT_SECRET}
EOF

echo ""
echo "✅ Fichier $ENV_FILE créé avec succès."
echo ""

# --- Option : lancer docker-compose ---
read -rp "🚀 Lancer 'docker compose up --build -d' maintenant ? (o/N) : " START
if [[ "$START" == "o" || "$START" == "O" ]]; then
  echo ""
  echo "▶️  Démarrage des services..."
  docker compose up --build -d
else
  echo ""
  echo "ℹ️  Pour démarrer les services, exécutez :"
  echo "   docker compose up --build -d"
fi

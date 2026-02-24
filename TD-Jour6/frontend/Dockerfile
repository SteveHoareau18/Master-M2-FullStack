# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app

# Copie des fichiers de dépendances
COPY package*.json ./

# Installation des dépendances (optimisée pour la production comme demandé dans les indices)
# Note: npm cache clean est ajouté pour optimiser l'espace temporaire [2]
RUN npm install && npm cache clean --force

# Copie du code source
COPY . .

# Construction de l'application (génère le dossier /dist)
RUN npm run build

# Stage 2: Production
FROM nginx:alpine

# Copie uniquement des fichiers buildés depuis le stage "builder" vers Nginx [1]
COPY --from=builder /app/dist /usr/share/nginx/html

# Copie de la configuration Nginx personnalisée requise pour le routing SPA [1], [3]
COPY nginx.conf /etc/nginx/nginx.conf

# Exposition du port 80 [1]
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
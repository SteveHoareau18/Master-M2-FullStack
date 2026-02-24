#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
GRAY='\033[0;90m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Liste des services à scanner
services=(
    "frontend"
    "api-gateway"
    "orders-api"
    "products-api"
    "auth-service"
    "postgres"
)

# Tableau associatif pour stocker les résultats
declare -A results

# Niveaux de sévérité possibles
severities=("CRITICAL" "HIGH" "MEDIUM" "LOW" "UNKNOWN")

echo -e "${BLUE}${BOLD}🔍 Scanning Docker images for vulnerabilities...${NC}"
echo ""

# Scanner chaque service
for service in "${services[@]}"; do
    echo -e "${GRAY}Scanning $service...${NC}"
    
    # Commande Trivy avec options spécifiques
    if [ "$service" = "frontend" ]; then
        scan_output=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.69.1 image \
            --skip-dirs /root/.npm/_cacache \
            --format json \
            td-jour6-cloudshop-$service:latest 2>/dev/null)
    else
        scan_output=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.69.1 image \
            --format json \
            td-jour6-cloudshop-$service:latest 2>/dev/null)
    fi
    
    # Extraire les comptages par sévérité
    for severity in "${severities[@]}"; do
        count=$(echo "$scan_output" | jq -r "[.Results[]?.Vulnerabilities[]? | select(.Severity == \"$severity\")] | length")
        results["${service}_${severity}"]=$count
    done
done

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║                       📊 VULNERABILITY MATRIX                              ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Afficher l'en-tête avec couleurs
printf "${BOLD}%-20s${NC}" "SERVICE"
printf "${RED}%-12s${NC}" "CRITICAL"
printf "${ORANGE}%-12s${NC}" "HIGH"
printf "${YELLOW}%-12s${NC}" "MEDIUM"
printf "${GREEN}%-12s${NC}" "LOW"
printf "${GRAY}%-12s${NC}" "UNKNOWN"
printf "${BOLD}%-12s${NC}\n" "TOTAL"

# Ligne de séparation
printf "%.s─" {1..92}
echo ""

# Afficher les données pour chaque service
for service in "${services[@]}"; do
    printf "%-20s" "$service"
    total=0
    
    for severity in "${severities[@]}"; do
        count=${results["${service}_${severity}"]}
        
        # Choisir la couleur selon la sévérité
        case $severity in
            "CRITICAL")
                if [ $count -gt 0 ]; then
                    printf "${RED}%-12s${NC}" "$count"
                else
                    printf "%-12s" "$count"
                fi
                ;;
            "HIGH")
                if [ $count -gt 0 ]; then
                    printf "${ORANGE}%-12s${NC}" "$count"
                else
                    printf "%-12s" "$count"
                fi
                ;;
            "MEDIUM")
                if [ $count -gt 0 ]; then
                    printf "${YELLOW}%-12s${NC}" "$count"
                else
                    printf "%-12s" "$count"
                fi
                ;;
            "LOW")
                if [ $count -gt 0 ]; then
                    printf "${GREEN}%-12s${NC}" "$count"
                else
                    printf "%-12s" "$count"
                fi
                ;;
            "UNKNOWN")
                if [ $count -gt 0 ]; then
                    printf "${GRAY}%-12s${NC}" "$count"
                else
                    printf "%-12s" "$count"
                fi
                ;;
        esac
        
        total=$((total + count))
    done
    
    printf "${BOLD}%-12s${NC}\n" "$total"
done

# Ligne de séparation
printf "%.s─" {1..92}
echo ""

# Afficher les totaux par colonne
printf "${BOLD}%-20s${NC}" "TOTAL"
grand_total=0

for severity in "${severities[@]}"; do
    column_total=0
    for service in "${services[@]}"; do
        count=${results["${service}_${severity}"]}
        column_total=$((column_total + count))
    done
    
    # Couleur pour les totaux
    case $severity in
        "CRITICAL") printf "${RED}${BOLD}%-12s${NC}" "$column_total" ;;
        "HIGH") printf "${ORANGE}${BOLD}%-12s${NC}" "$column_total" ;;
        "MEDIUM") printf "${YELLOW}${BOLD}%-12s${NC}" "$column_total" ;;
        "LOW") printf "${GREEN}${BOLD}%-12s${NC}" "$column_total" ;;
        "UNKNOWN") printf "${GRAY}${BOLD}%-12s${NC}" "$column_total" ;;
    esac
    
    grand_total=$((grand_total + column_total))
done

printf "${BOLD}%-12s${NC}\n" "$grand_total"

echo ""
echo -e "${GREEN}✅ Scan complete!${NC}"
echo ""
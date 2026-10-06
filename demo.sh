#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  COOLANT — Live Project Dashboard
#  Run: bash demo.sh
# ═══════════════════════════════════════════════════════════════

cd "$(dirname "$0")" || exit 1

# Colors
BOLD="\033[1m"; DIM="\033[2m"
CYAN="\033[36m"; GREEN="\033[32m"; YELLOW="\033[33m"
BLUE="\033[34m"; MAGENTA="\033[35m"; RED="\033[31m"
RESET="\033[0m"

spin() {
  local pid=$1
  local chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  ${CYAN}%s${RESET}  %s" "${chars:$i:1}" "$2"
    i=$(( (i + 1) % ${#chars} ))
    sleep 0.08
  done
  printf "\r  ${GREEN}✓${RESET}  %s\n" "$2"
}

# ─── Banner ───
clear
printf "\n${BOLD}${CYAN}"
cat << 'BANNER'
   ╔═══════════════════════════════════════════════════════════╗
   ║                                                           ║
   ║        ██████╗ ██████╗  ██████╗ ██╗      █████╗ ███╗   ██╗║
   ║       ██╔════╝██╔═══██╗██╔═══██╗██║     ██╔══██╗████╗  ██║║
   ║       ██║     ██║   ██║██║   ██║██║     ███████║██╔██╗ ██║║
   ║       ██║     ██║   ██║██║   ██║██║     ██╔══██║██║╚██╗██║║
   ║       ╚██████╗╚██████╔╝╚██████╔╝███████╗██║  ██║██║ ╚████║║
   ║        ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝║
   ║                                                           ║
   ║       Predictive ML for HPC Thermal Management            ║
   ║       Frontier Exascale · Oak Ridge National Lab          ║
   ║                                                           ║
   ╚═══════════════════════════════════════════════════════════╝
BANNER
printf "${RESET}\n"

# ─── Loading animation ───
printf "${BOLD}${YELLOW}  Loading project state...${RESET}\n\n"

(sleep 0.4) & spin $! "Scanning notebooks..."
(sleep 0.3) & spin $! "Indexing figures..."
(sleep 0.3) & spin $! "Reading model metadata..."
(sleep 0.3) & spin $! "Connecting to git..."
echo ""

# ─── Project stats ───
NB_COUNT=$(ls notebooks/*.ipynb 2>/dev/null | wc -l)
FIG_COUNT=$(find figures -name '*.png' 2>/dev/null | wc -l)
PY_LINES=$(find src notebooks -name '*.py' -o -name '*.ipynb' 2>/dev/null | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "—")
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "—")
MODELS=$(ls models/*.json 2>/dev/null | wc -l)
DISK=$(du -sh . 2>/dev/null | cut -f1)

printf "${BOLD}${MAGENTA}  ╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${BOLD}PROJECT METRICS${RESET}                                         ${BOLD}${MAGENTA}║${RESET}\n"
printf "${BOLD}${MAGENTA}  ╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Dataset${RESET}          Frontier HPC · 49,869 rows       ${BOLD}${MAGENTA}║${RESET}\n"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Notebooks${RESET}        ${BOLD}${GREEN}%-3s${RESET} analyzed                          ${BOLD}${MAGENTA}║${RESET}\n" "$NB_COUNT"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Figures${RESET}          ${BOLD}${GREEN}%-3s${RESET} generated                         ${BOLD}${MAGENTA}║${RESET}\n" "$FIG_COUNT"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Model files${RESET}      ${BOLD}${GREEN}%-3s${RESET} saved                             ${BOLD}${MAGENTA}║${RESET}\n" "$MODELS"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Lines of code${RESET}    ${BOLD}${GREEN}%-6s${RESET}                          ${BOLD}${MAGENTA}║${RESET}\n" "$PY_LINES"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Repo size${RESET}        ${BOLD}${GREEN}%-6s${RESET}                          ${BOLD}${MAGENTA}║${RESET}\n" "$DISK"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Git branch${RESET}       ${BOLD}${CYAN}%-20s${RESET}              ${BOLD}${MAGENTA}║${RESET}\n" "$BRANCH"
printf "${BOLD}${MAGENTA}  ║${RESET}  ${DIM}Latest commit${RESET}    ${BOLD}${CYAN}%-20s${RESET}              ${BOLD}${MAGENTA}║${RESET}\n" "$COMMIT"
printf "${BOLD}${MAGENTA}  ╚══════════════════════════════════════════════════════════╝${RESET}\n"
echo ""

# ─── Headline results ───
printf "${BOLD}${GREEN}  ╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${BOLD}${GREEN}  ║${RESET}  ${BOLD}HEADLINE RESULTS${RESET}                                        ${BOLD}${GREEN}║${RESET}\n"
printf "${BOLD}${GREEN}  ╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${BOLD}${GREEN}  ║${RESET}  Regression MAE      ${BOLD}${YELLOW}0.831 °C${RESET}                          ${BOLD}${GREEN}║${RESET}\n"
printf "${BOLD}${GREEN}  ║${RESET}  HIGH recall         ${BOLD}${YELLOW}76.7%%${RESET}                             ${BOLD}${GREEN}║${RESET}\n"
printf "${BOLD}${GREEN}  ║${RESET}  Degree-min reduction${BOLD}${YELLOW} 90.6%%${RESET}                            ${BOLD}${GREEN}║${RESET}\n"
printf "${BOLD}${GREEN}  ║${RESET}  Warning lead time   ${BOLD}${YELLOW}115 min${RESET}                          ${BOLD}${GREEN}║${RESET}\n"
printf "${BOLD}${GREEN}  ║${RESET}  Events avoided      ${BOLD}${YELLOW}83.6%%${RESET}                             ${BOLD}${GREEN}║${RESET}\n"
printf "${BOLD}${GREEN}  ╚══════════════════════════════════════════════════════════╝${RESET}\n"
echo ""

# ─── Sparkline of figures by phase ───
printf "${BOLD}${BLUE}  Figures by phase:${RESET}\n"
for dir in eda preprocessing classification regression comparison rigor value uncertainty cross_domain control; do
  n=$(find "figures/$dir" -name '*.png' 2>/dev/null | wc -l)
  if [ "$n" -gt 0 ]; then
    bar=$(printf '█%.0s' $(seq 1 $((n / 2))))
    printf "    ${DIM}%-15s${RESET}  ${CYAN}%-40s${RESET}  ${BOLD}%3s${RESET}\n" "$dir" "$bar" "$n"
  fi
done
echo ""

# ─── Footer ───
printf "${DIM}  https://github.com/adityajha1606/coolant-project${RESET}\n"
printf "${DIM}  Built with Python 3.10 · LightGBM · XGBoost · scikit-learn${RESET}\n"
printf "\n${BOLD}${CYAN}  ✓ Dashboard ready${RESET}\n\n"

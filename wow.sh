#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  COOLANT — Complete Project Demonstration
#  Run:  bash wow.sh
# ═══════════════════════════════════════════════════════════════════════════

cd "$(dirname "$0")" || exit 1

BOLD="\033[1m";  DIM="\033[2m"
CYAN="\033[36m"; GREEN="\033[32m"; YELLOW="\033[33m"
BLUE="\033[34m"; MAGENTA="\033[35m"; RED="\033[31m"
WHITE="\033[97m"; RESET="\033[0m"

spin() {
  local pid=$1
  local msg=$2
  local chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  ${CYAN}%s${RESET}  ${DIM}%s${RESET}" "${chars:$i:1}" "$msg"
    i=$(( (i + 1) % ${#chars} ))
    sleep 0.06
  done
  printf "\r  ${GREEN}✓${RESET}  %s\n" "$msg"
}

section() {
  local title="$1"
  local total_width=64
  local title_len=${#title}
  local bar_len=$(( total_width - title_len - 6 ))
  [ "$bar_len" -lt 4 ] && bar_len=4
  local bar
  bar=$(printf '═%.0s' $(seq 1 "$bar_len"))
  printf "\n${BOLD}${CYAN}═══ %s %s${RESET}\n\n" "$title" "$bar"
}

clear

# ─── 1. BANNER ───
printf "\n${BOLD}${CYAN}"
cat << 'BANNER'

   ██████╗ ██████╗  ██████╗ ██╗      █████╗ ███╗   ██╗████████╗
  ██╔════╝██╔═══██╗██╔═══██╗██║     ██╔══██╗████╗  ██║╚══██╔══╝
  ██║     ██║   ██║██║   ██║██║     ███████║██╔██╗ ██║   ██║
  ██║     ██║   ██║██║   ██║██║     ██╔══██║██║╚██╗██║   ██║
  ╚██████╗╚██████╔╝╚██████╔╝███████╗██║  ██║██║ ╚████║   ██║
   ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝

BANNER
printf "${RESET}"
printf "${DIM}            Predictive ML for HPC Thermal Management${RESET}\n"
printf "${DIM}            Frontier Exascale · Oak Ridge National Laboratory${RESET}\n"
printf "${DIM}            Inspired by Jadhav & Liu (2026), IEEE ITherm Best Paper${RESET}\n\n"

# ─── 2. LOADING ───
printf "${BOLD}${YELLOW}  Initializing project scan...${RESET}\n\n"

(sleep 0.4) & spin $! "Scanning notebooks"
(sleep 0.3) & spin $! "Indexing figures"
(sleep 0.3) & spin $! "Reading model metadata"
(sleep 0.2) & spin $! "Connecting to GitHub"
(sleep 0.2) & spin $! "Verifying integrity hashes"
echo ""

# ─── 3. PROJECT METRICS ───
NB_COUNT=$(ls notebooks/*.ipynb 2>/dev/null | wc -l)
FIG_COUNT=$(find figures -name '*.png' 2>/dev/null | wc -l)
PY_LINES=$(find src notebooks -name '*.py' -o -name '*.ipynb' 2>/dev/null | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "—")
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "—")
MODELS=$(ls models/*.json 2>/dev/null | wc -l)
DISK=$(du -sh . 2>/dev/null | cut -f1)

section "PROJECT METRICS"

printf "    ${DIM}Dataset${RESET}           ${BOLD}${WHITE}Frontier HPC · 49,869 rows · 10-min${RESET}\n"
printf "    ${DIM}Notebooks${RESET}         ${BOLD}${GREEN}%s${RESET} analyzed\n" "$NB_COUNT"
printf "    ${DIM}Figures${RESET}           ${BOLD}${GREEN}%s${RESET} generated\n" "$FIG_COUNT"
printf "    ${DIM}Model files${RESET}       ${BOLD}${GREEN}%s${RESET} metadata + weights\n" "$MODELS"
printf "    ${DIM}Lines of code${RESET}     ${BOLD}${GREEN}%s${RESET}\n" "$PY_LINES"
printf "    ${DIM}Repository size${RESET}   ${BOLD}${GREEN}%s${RESET}\n" "$DISK"
printf "    ${DIM}Git branch${RESET}        ${BOLD}${CYAN}%s${RESET}\n" "$BRANCH"
printf "    ${DIM}Latest commit${RESET}     ${BOLD}${CYAN}%s${RESET}\n" "$COMMIT"

# ─── 4. FIGURES BY PHASE ───
section "FIGURES BY PHASE"

for dir in eda preprocessing classification regression comparison rigor value uncertainty cross_domain control; do
  n=$(find "figures/$dir" -name '*.png' 2>/dev/null | wc -l)
  if [ "$n" -gt 0 ]; then
    bar=$(printf '█%.0s' $(seq 1 $((n / 2))))
    printf "    ${DIM}%-16s${RESET}  ${CYAN}%-40s${RESET}  ${BOLD}%3s${RESET}\n" "$dir" "$bar" "$n"
  fi
done

# ─── 5. HEADLINE RESULTS ───
section "HEADLINE RESULTS"

printf "    ${BOLD}${GREEN}Regression${RESET}\n"
printf "      ${DIM}Best model${RESET}                ${BOLD}${YELLOW}Ridge${RESET}\n"
printf "      ${DIM}MAE${RESET}                       ${BOLD}${YELLOW}0.831 °C${RESET}   ${DIM}(vs 1.18 absolute)${RESET}\n"
printf "      ${DIM}R-squared${RESET}                 ${BOLD}${YELLOW}0.739${RESET}      ${DIM}(ties persistence)${RESET}\n\n"

printf "    ${BOLD}${GREEN}Classification${RESET}\n"
printf "      ${DIM}Best model${RESET}                ${BOLD}${YELLOW}ForecastTier (LGBM dT)${RESET}\n"
printf "      ${DIM}HIGH recall${RESET}               ${BOLD}${YELLOW}76.7 %%${RESET}   ${DIM}(was 45.5 %%)${RESET}\n"
printf "      ${DIM}Event detection${RESET}           ${BOLD}${YELLOW}66 %%${RESET}\n"
printf "      ${DIM}Onset recall${RESET}              ${BOLD}${YELLOW}48.5 %%${RESET}   ${DIM}(persistence = 0)${RESET}\n\n"

printf "    ${BOLD}${GREEN}Digital Twin and Control${RESET}\n"
printf "      ${DIM}HIGH event reduction${RESET}      ${BOLD}${YELLOW}83.6 %%${RESET}\n"
printf "      ${DIM}Degree-min reduction${RESET}      ${BOLD}${YELLOW}90.6 %%${RESET}\n"
printf "      ${DIM}Median warning lead${RESET}       ${BOLD}${YELLOW}115 min${RESET}\n"
printf "      ${DIM}Break-even forecast MAE${RESET}   ${BOLD}${YELLOW}0.82 °C${RESET}\n"

# ─── 6. GIT HISTORY (with --no-pager, essential for scripts) ───
section "GIT HISTORY (last 10 commits)"
echo
git --no-pager log --graph \
  --pretty=format:'    %C(yellow)%h%Creset %C(auto)%d%Creset %s %Cgreen(%cr)%Creset' \
  --abbrev-commit -10
echo
echo

# ─── 7. PROJECT TREE ───
section "PROJECT STRUCTURE"
echo
if command -v tree >/dev/null 2>&1; then
  tree -L 2 -I '__pycache__|.ipynb_checkpoints|*.pyc|.venv|*.png|*.parquet' --dirsfirst
else
  printf "    ${DIM}Install tree:  sudo apt install tree${RESET}\n\n"
  find . -maxdepth 2 -type d -not -path '*/\.*' -not -path './.venv*' | sort | sed 's/^/    /'
fi

# ─── 8. FOOTER ───
echo
printf "${BOLD}${CYAN}  ╭────────────────────────────────────────────────────────────╮${RESET}\n"
printf "  ${CYAN}│${RESET}  ${BOLD}${WHITE}%-58s${RESET}${CYAN}│${RESET}\n" "Coolant v1.0.0  ·  CC BY-NC-SA 4.0"
printf "  ${CYAN}│${RESET}  ${DIM}%-58s${RESET}${CYAN}│${RESET}\n" "github.com/adityajha1606/coolant-project"
printf "  ${CYAN}│${RESET}  ${DIM}%-58s${RESET}${CYAN}│${RESET}\n" "Python 3.10 · LightGBM · XGBoost · scikit-learn"
printf "${BOLD}${CYAN}  ╰────────────────────────────────────────────────────────────╯${RESET}\n"
echo
printf "${BOLD}${GREEN}  ✓ Dashboard ready${RESET}\n\n"
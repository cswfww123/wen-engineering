#!/usr/bin/env bash
set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p " [Enter when done] " _
}

capture() {
  local var="$1"
  local question="$2"
  local answer
  printf '\n>>> %s\n' "$question"
  read -r -p " > " answer
  printf -v "$var" '%s' "$answer"
}

# Copy this file, replace the example steps, and run it.
# The user follows the prompts; the agent parses the captured output.

step "Open the application and navigate to the failing flow."
capture REPRODUCED "Did the reported bug reproduce? (y/n)"
capture SYMPTOM "Paste the exact error message, wrong output, or visible symptom:"

printf '\n--- Captured ---\n'
printf 'REPRODUCED=%s\n' "$REPRODUCED"
printf 'SYMPTOM=%s\n' "$SYMPTOM"

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_brain_unify info
PYTHONPATH=src python -m gbt_brain_unify check --payload '{"goal": "<在此填写>"}'
PYTHONPATH=src python -m gbt_brain_unify run   --payload '{"goal": "<在此填写>"}'

#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${ROOT_DIR}/src"
MODULES_DIR="${SRC_DIR}/modules"

ROOT_CONFIG="${ROOT_DIR}/.terraform-docs.yml"
MODULE_CONFIG="${ROOT_DIR}/.terraform-docs-module.yml"

DOCS_DIR="${ROOT_DIR}/docs"
ROOT_DOC="${DOCS_DIR}/DIRECTORY_STRUCTURE.md"

echo "🏆 Terraform Registry-Level Docs Generator"
echo "📁 ROOT: ${ROOT_DIR}"

# ----------------------------------------------------------------------
# terraform-docs check
# ----------------------------------------------------------------------
if ! command -v terraform-docs >/dev/null 2>&1; then
  echo "❌ terraform-docs not installed"
  exit 1
fi

echo "✅ terraform-docs: $(terraform-docs --version)"

# ----------------------------------------------------------------------
# validate configs
# ----------------------------------------------------------------------
[ -f "${ROOT_CONFIG}" ] || { echo "❌ missing root config"; exit 1; }
[ -f "${MODULE_CONFIG}" ] || { echo "❌ missing module config"; exit 1; }

mkdir -p "${DOCS_DIR}"

# ----------------------------------------------------------------------
# ROOT DOC (Registry style)
# ----------------------------------------------------------------------
if [ ! -f "${ROOT_DOC}" ]; then
  cat > "${ROOT_DOC}" <<'EOF'
# 📦 Terraform Infrastructure

Production-ready Terraform modules and infrastructure.

---

## 📚 Documentation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
EOF
fi

# ----------------------------------------------------------------------
# ROOT generation
# ----------------------------------------------------------------------
echo "⚙️ Generating ROOT documentation..."

terraform-docs \
  --config "${ROOT_CONFIG}" \
  "${SRC_DIR}"

echo "✅ ROOT done"

# ----------------------------------------------------------------------
# MODULES (Registry-level README generation)
# ----------------------------------------------------------------------
echo "⚙️ Generating MODULE documentation..."

for module in "${MODULES_DIR}"/*; do

  [ -d "${module}" ] || continue

  name=$(basename "${module}")
  readme="${module}/README.md"

  echo ""
  echo "📦 Module: ${name}"

  # ------------------------------------------------------------------
  # Registry-style README header (like HashiCorp)
  # ------------------------------------------------------------------
  cat > "${readme}" <<EOF
# Terraform Module: ${name}

---

## 📌 Overview

Production-grade Terraform module: **${name}**

---

## 📚 Documentation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
EOF

  # ------------------------------------------------------------------
  # generate docs
  # ------------------------------------------------------------------
  terraform-docs \
    --config "${MODULE_CONFIG}" \
    "${module}"

  echo "✅ ${name} → Registry docs generated"

done

# ----------------------------------------------------------------------
# git diff
# ----------------------------------------------------------------------
if command -v git >/dev/null 2>&1 && git -C "${ROOT_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo ""
  echo "🔍 Git diff:"
  git -C "${ROOT_DIR}" --no-pager diff -- "${DOCS_DIR}" || true
fi

echo ""
echo "🏆 TERRAFORM REGISTRY-LEVEL DOCS READY"
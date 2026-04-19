#!/usr/bin/env bash
# ======================================================================
# 🚀 Terraform Registry-Level Documentation Generator
# ======================================================================
# Назначение: Генерация документации root-конфига и всех модулей.
# Расположение: Должен находиться в папке scripts/ корневого каталога.
# Зависимости: terraform, terraform-docs, tree (опционально)
# ======================================================================

set -euo pipefail

# ======================================================================
# 📁 Определение путей (работает из любой рабочей директории)
# ======================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

SRC_DIR="${ROOT_DIR}/src"
MODULES_DIR="${SRC_DIR}/modules"
ROOT_CONFIG="${ROOT_DIR}/.terraform-docs.yml"
MODULE_CONFIG="${ROOT_DIR}/.terraform-docs-module.yml"
DOCS_DIR="${ROOT_DIR}/docs"
ROOT_DOC="${DOCS_DIR}/DIRECTORY_STRUCTURE.md"

echo "🏆 Terraform Docs Generator"
echo "📁 Project Root: ${ROOT_DIR}"

# ======================================================================
# 🔍 Проверка зависимостей
# ======================================================================
if ! command -v terraform-docs >/dev/null 2>&1; then
  echo "❌ terraform-docs не установлен"
  echo "👉 Установка: brew install terraform-docs || go install github.com/terraform-docs/terraform-docs@latest"
  exit 1
fi
echo "✅ terraform-docs: $(terraform-docs --version)"

TREE_AVAILABLE=false
command -v tree >/dev/null 2>&1 && TREE_AVAILABLE=true

# ======================================================================
# 📦 Проверка конфигурационных файлов
# ======================================================================
[ -f "${ROOT_CONFIG}" ] || { echo "❌ Отсутствует: ${ROOT_CONFIG}"; exit 1; }
[ -f "${MODULE_CONFIG}" ] || { echo "❌ Отсутствует: ${MODULE_CONFIG}"; exit 1; }

mkdir -p "${DOCS_DIR}"

# ======================================================================
# 📄 Создание скелета ROOT документации (если файла нет)
# ======================================================================
if [[ ! -f "${ROOT_DOC}" ]]; then
  echo "🆕 Создаём структуру root документации..."
  
  PROJECT_TREE="[tree не установлен или директория src отсутствует]"
  if [[ "$TREE_AVAILABLE" == true && -d "${SRC_DIR}" ]]; then
    PROJECT_TREE=$(cd "${ROOT_DIR}" && tree -a -I '.git|.terraform|node_modules|*.tfstate*|docs|.idea|*.lock|*.yaml|*.yml|*.tfvars.example' src --noreport 2>/dev/null) || true
  fi

  cat > "${ROOT_DOC}" <<EOF
# 📦 Terraform Infrastructure

---

## 📚 Автоматически сгенерированная документация

---

## 🌳 Структура проекта

\`\`\`
${PROJECT_TREE}
\`\`\`

---

## 📘 Пояснения к структуре

| Путь | Описание |
|------|----------|
| \`src/main.tf\` | Точка входа: объединяет все модули |
| \`src/providers.tf\` | Настройка провайдеров и backend |
| \`src/variables.tf\` | Входные переменные |
| \`src/terraform.tfvars\` | Значения переменных |
| \`src/output.tf\` | Выходные значения |
| \`src/modules/\` | Каталог всех Terraform модулей |



---

## 📖 Документация Terraform (Root)

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
EOF
fi

# ======================================================================
# ⚙️ ГЕНЕРАЦИЯ ROOT ДОКУМЕНТАЦИИ
# ======================================================================
echo "⚙️ Подготовка и генерация ROOT документации..."

# 1. Безопасный init для корректного парсинга версий провайдеров и ресурсов
if [[ -d "${SRC_DIR}" ]] && shopt -s nullglob; tf_files=("${SRC_DIR}"/*.tf); shopt -u nullglob; [[ ${#tf_files[@]} -gt 0 ]]; then
  echo "🔄 Запуск terraform init (без backend)..."
  terraform -chdir="${SRC_DIR}" init -backend=false -input=false -no-color &>/dev/null || echo "⚠️  terraform init пропущен (не критично)"
fi

# 2. Генерация с явным переопределением пути вывода (игнорирует возможные ../ в конфиге)
terraform-docs \
  --config "${ROOT_CONFIG}" \
  --output-file "${ROOT_DOC}" \
  --output-mode inject \
  "${SRC_DIR}"

echo "✅ ROOT документация обновлена"

# ======================================================================
# 📦 ГЕНЕРАЦИЯ ДОКУМЕНТАЦИИ МОДУЛЕЙ
# ======================================================================
echo "⚙️ Генерация документации модулей..."

if [[ ! -d "${MODULES_DIR}" ]]; then
  echo "⚠️  Директория модулей не найдена: ${MODULES_DIR}"
else
  for module in "${MODULES_DIR}"/*/; do
    [[ -d "${module}" ]] || continue
    module_name=$(basename "${module}")
    readme="${module}/README.md"

    echo "📦 Обработка модуля: ${module_name}"

    # Создание заглушки README, если отсутствует
    if [[ ! -f "${readme}" ]]; then
      cat > "${readme}" <<EOF
# Terraform Module: ${module_name}

---

## 📌 Описание
Модуль инфраструктуры: **${module_name}**

---

## 📚 Документация
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
EOF
    fi

    # Генерация документации модуля
    terraform-docs \
      --config "${MODULE_CONFIG}" \
      --output-file "${readme}" \
      --output-mode inject \
      "${module}"

    echo "✅ ${module_name} готово"
  done
fi

# ======================================================================
# 🔍 Git статус (опционально)
# ======================================================================
if command -v git >/dev/null 2>&1 && git -C "${ROOT_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo ""
  echo "🔍 Изменения в документации:"
  git -C "${ROOT_DIR}" --no-pager diff --stat -- "${DOCS_DIR}" || true
fi

echo ""
echo "🏆 ГОТОВО: документация успешно сгенерирована"

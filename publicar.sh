#!/bin/bash
# 1. Limpiar y Renderizar el artículo
quarto render articulos

# 2. Preparar todos los cambios (HTML, JSON de búsqueda, etc.)
git add .

# 3. Commit automático con marca de tiempo
git commit -m "web: actualización automática $(date +'%Y-%m-%d %H:%M')"

# 4. Enviar a GitHub
git push origin main
# publicar.R
# Publica el sitio growise.com.ar completo: limpia caché, renderiza, commit y push.
#
# Prerrequisito: pausar la sincronización de OneDrive antes de correr este script.
# El repo local vive en OneDrive y el lock de git en .git/logs/refs/heads/main
# se genera si OneDrive sincroniza en paralelo al commit.
#
# Uso: correr desde RStudio con el working directory en la raíz del repo
# (C:\Users\mjlam\OneDrive\Documentos\Proyectos_R\Growise_Web), o ajustar
# repo_path abajo.

repo_path <- "C:/Users/mjlam/OneDrive/Documentos/Proyectos_R/Growise_Web"
setwd(repo_path)

# 1. Borrar caché de Quarto
# Necesario: sin este paso se reproduce el error de I/O de Deno KV SQLite
# ya diagnosticado (ver plan-estrategico-2026-08-sesion.md).
cache_dir <- file.path(repo_path, ".quarto")
if (dir.exists(cache_dir)) {
  unlink(cache_dir, recursive = TRUE, force = TRUE)
  message("Caché .quarto eliminada.")
} else {
  message("No había caché .quarto para eliminar.")
}

# 2. Renderizar el sitio completo (no solo articulos/)
render_status <- system("quarto render", intern = FALSE)
if (render_status != 0) {
  stop("quarto render falló. Revisar el output antes de continuar con el commit.")
}
message("Render completo OK.")

# 3. Commit
system("git add .")
commit_msg <- paste0("web: actualización automática ", format(Sys.time(), "%Y-%m-%d %H:%M"))
commit_status <- system(paste0('git commit -m "', commit_msg, '"'))

if (commit_status != 0) {
  message("git commit no generó cambios (nada para commitear) o falló — revisar manualmente.")
} else {
  # 4. Push
  push_status <- system("git push origin main")
  if (push_status != 0) {
    stop("git push falló. Revisar credenciales/conexión antes de reintentar.")
  }
  message("Push a origin/main OK. Publicación completa.")
}

#!/usr/bin/env bash

# ─── run_cobol.sh ──────────────────────────────────────
# Script seguro para compilar y ejecutar programas COBOL.
# Uso: ./run_cobol.sh programa.cob
# Autor: Lucas (con ayuda de su asistente)
# Licencia: MIT
# ────────────────────────────────────────────────────────

set -euo pipefail

# ─── CONFIGURACIÓN ─────────────────────────────────────
readonly BACKUP_DIR="backups"
readonly LOG_DIR="logs"
readonly RESUMEN_LOG="$LOG_DIR/resumen.log"
# ────────────────────────────────────────────────────────

# ─── FUNCIONES ─────────────────────────────────────────
# DEFINIR log ANTES de cualquier otra función que lo use
log() {
    local mensaje="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensaje"
}

usage() {
    echo "Uso: $0 <archivo.cob>"
    echo "Ejemplo: $0 samples/altkey/altkey.cob"
    exit 2
}

cleanup() {
    log "Limpiando archivos temporales..."
    rm -f /tmp/run_cobol_*.tmp
    log "Limpieza completada."
}

# Detectar formato (fixed/free) del archivo COBOL
# Detectar formato (fixed/free) del archivo COBOL
detectar_formato() {
    local archivo="$1"
    local lineas_a_revisar=20
    local contador=0

    # Buscar líneas con código en la zona fija (columna 8-72).
    # Formato fijo: 6 cols número, 1 col indicador, código desde col 8.
    contador=$(head -n "$lineas_a_revisar" "$archivo" | awk '
        length($0) >= 8 {
            indicador = substr($0, 7, 1)    # Columna 7
            codigo    = substr($0, 8, 1)    # Columna 8
            # Si no es comentario (indicador no es *) y hay código
            # en columna 8 (no es espacio), asumimos formato fijo.
            if (indicador != "*" && codigo != " ") {
                count++
            }
        }
        END { print count+0 }   # +0 asegura que sea numérico
    ')

    if [ "$contador" -gt 0 ]; then
        echo "fixed"
    else
        echo "free"
    fi
}

trap cleanup EXIT INT TERM
# ────────────────────────────────────────────────────────

# ─── VALIDAR ARGUMENTOS ────────────────────────────────
if [ $# -ne 1 ]; then
    log "ERROR: Se esperaba 1 argumento, se recibieron $#."
    usage
fi

ARCHIVO_COB="$1"

if [ ! -f "$ARCHIVO_COB" ]; then
    log "ERROR: El archivo '$ARCHIVO_COB' no existe."
    exit 2
fi

if [[ "$ARCHIVO_COB" != *.cob ]]; then
    log "ERROR: El archivo debe tener extensión .cob"
    exit 2
fi
# ────────────────────────────────────────────────────────

# ─── VERIFICAR DEPENDENCIAS ────────────────────────────
if ! command -v cobc &> /dev/null; then
    log "ERROR: 'cobc' no encontrado. Instalá GnuCOBOL:"
    log "  Ubuntu/Debian: sudo apt install gnucobol"
    log "  Fedora:        sudo dnf install gnucobol"
    log "  Mac:           brew install gnucobol"
    exit 127
fi
# ────────────────────────────────────────────────────────

# ─── PREPARAR DIRECTORIOS ──────────────────────────────
mkdir -p "$BACKUP_DIR" "$LOG_DIR"
log "Directorios '$BACKUP_DIR' y '$LOG_DIR' listos."

PROGRAMA="${ARCHIVO_COB%.cob}"
EJECUTABLE="./$PROGRAMA"
# ────────────────────────────────────────────────────────

# ─── BACKUP DEL EJECUTABLE ANTERIOR ────────────────────
BACKUP_RUTA="$BACKUP_DIR/$(dirname "$ARCHIVO_COB")"
BACKUP_FILE="$BACKUP_RUTA/$(basename "$PROGRAMA")_$(date +%Y%m%d_%H%M%S).bak"
mkdir -p "$BACKUP_RUTA"

if [ -f "$PROGRAMA" ]; then
    cp "$PROGRAMA" "$BACKUP_FILE"
    log "Backup creado: $BACKUP_FILE"
fi
# ────────────────────────────────────────────────────────

# ─── COMPILAR ──────────────────────────────────────────
log "Compilando '$ARCHIVO_COB'..."

# Detectar formato automáticamente (LLAMAR DESPUÉS DE DEFINIR ARCHIVO_COB)
FORMATO=$(detectar_formato "$ARCHIVO_COB")
log "Formato detectado: $FORMATO"

if cobc -x -"$FORMATO" -o "$PROGRAMA" "$ARCHIVO_COB"; then
    log "Compilación exitosa."
else
    log "ERROR: Falló la compilación de '$ARCHIVO_COB'."
    exit 1
fi
# ────────────────────────────────────────────────────────

# ─── EJECUTAR (UNA SOLA VEZ) ───────────────────────────
LOG_RUTA="$LOG_DIR/$(dirname "$ARCHIVO_COB")"
LOG_ARCHIVO="$LOG_RUTA/$(basename "$PROGRAMA")_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_RUTA"

log "Ejecutando '$EJECUTABLE'..."
log "Salida guardada en: $LOG_ARCHIVO"

# Ejecutar, mostrando en pantalla y guardando en log
"$EJECUTABLE" 2>&1 | tee "$LOG_ARCHIVO"

EXIT_CODE=${PIPESTATUS[0]}
# ────────────────────────────────────────────────────────

# ─── REGISTRAR RESULTADO ───────────────────────────────
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $ARCHIVO_COB → $PROGRAMA (exit=$EXIT_CODE)" >> "$RESUMEN_LOG"

if [ "$EXIT_CODE" -eq 0 ]; then
    log "Programa finalizado correctamente (exit code $EXIT_CODE)."
else
    log "Programa terminó con errores (exit code $EXIT_CODE). Revisá el log."
fi
# ────────────────────────────────────────────────────────

exit "$EXIT_CODE"

#!/usr/bin/env bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR=$(cd "$(dirname "${0}")" && pwd)

THEME_NAME=Qogir
THEME_VARIANTS=('' '-Manjaro' '-Ubuntu')
COLOR_VARIANTS=('' '-Light' '-Dark')

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-t, --theme VARIANT" "Specify theme primary color variant(s) [default|manjaro|ubuntu|all] (Default: all themes)"
  printf "  %-25s%s\n" "-c, --color VARIANT" "Specify theme color variant(s) [standard|dark|all] (Default: all variants)"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

  local THEME_DIR=${dest}/${name}${theme}${color}

  [[ "$color" == '-Dark' ]] && local cursors_color="$color"

  [[ -d ${THEME_DIR} ]] && rm -rf "${THEME_DIR}"

  echo "Installing '${THEME_DIR}'..."

  mkdir -p "${THEME_DIR}"
  cp -r "${SRC_DIR}/COPYING" "${THEME_DIR}"
  cp -r "${SRC_DIR}/AUTHORS" "${THEME_DIR}"

  if [[ "${noapp:-}" == 'true' ]]; then
    cp -r "${SRC_DIR}/src/index-noapp.theme" "${THEME_DIR}/index.theme"
  else
    cp -r "${SRC_DIR}/src/index.theme" "${THEME_DIR}"
  fi

  if [[ ${color} != '-Light' ]]; then
    cp -r "${SRC_DIR}/src/cursors/dist${theme}${color}/cursors" "${THEME_DIR}"
  fi

  cd "${THEME_DIR}" || exit 1
  sed -i "s/${name}/${name}${theme}${color}/g" index.theme

  if [[ ${color} == '' ]]; then
    cp -r "${SRC_DIR}"/src/{16,22,24,32,48,96,128,scalable,symbolic} "${THEME_DIR}"
    cp -r "${SRC_DIR}"/links/{16,22,24,32,48,96,128,scalable,symbolic} "${THEME_DIR}"
    [[ ${theme} != '' ]] && \
    cp -r "${SRC_DIR}"/src/theme"${theme}"/* "${THEME_DIR}"
  elif [[ ${color} == '-Light' ]]; then
    mkdir -p "${THEME_DIR}"/{16,22,24}

    cp -r "${SRC_DIR}"/src/16/panel "${THEME_DIR}/16"
    cp -r "${SRC_DIR}"/src/22/panel "${THEME_DIR}/22"
    cp -r "${SRC_DIR}"/src/24/panel "${THEME_DIR}/24"

    sed -i "s/#d3dae3/#5d656b/g" "${THEME_DIR}"/{16,22,24}/panel/*.svg

    cp -r "${SRC_DIR}"/links/16/panel "${THEME_DIR}/16"
    cp -r "${SRC_DIR}"/links/22/panel "${THEME_DIR}/22"
    cp -r "${SRC_DIR}"/links/24/panel "${THEME_DIR}/24"

    cd "${dest}" || exit 1
    ln -sf "../${name}${theme}/cursors" "${name}${theme}-Light/cursors"
    ln -sf "../${name}${theme}/scalable" "${name}${theme}-Light/scalable"
    ln -sf "../${name}${theme}/symbolic" "${name}${theme}-Light/symbolic"
    ln -sf "../${name}${theme}/32" "${name}${theme}-Light/32"
    ln -sf "../${name}${theme}/48" "${name}${theme}-Light/48"
    ln -sf "../${name}${theme}/96" "${name}${theme}-Light/96"
    ln -sf "../${name}${theme}/128" "${name}${theme}-Light/128"
    ln -sf "../../${name}${theme}/16/apps" "${name}${theme}-Light/16/apps"
    ln -sf "../../${name}${theme}/16/actions" "${name}${theme}-Light/16/actions"
    ln -sf "../../${name}${theme}/16/places" "${name}${theme}-Light/16/places"
    ln -sf "../../${name}${theme}/16/devices" "${name}${theme}-Light/16/devices"
    ln -sf "../../${name}${theme}/16/emblems" "${name}${theme}-Light/16/emblems"
    ln -sf "../../${name}${theme}/16/mimetypes" "${name}${theme}-Light/16/mimetypes"
    ln -sf "../../${name}${theme}/16/status" "${name}${theme}-Light/16/status"
    ln -sf "../../${name}${theme}/22/emblems" "${name}${theme}-Light/22/emblems"
    ln -sf "../../${name}${theme}/22/mimetypes" "${name}${theme}-Light/22/mimetypes"
    ln -sf "../../${name}${theme}/22/actions" "${name}${theme}-Light/22/actions"
    ln -sf "../../${name}${theme}/22/places" "${name}${theme}-Light/22/places"
    ln -sf "../../${name}${theme}/22/devices" "${name}${theme}-Light/22/devices"
    ln -sf "../../${name}${theme}/24/animations" "${name}${theme}-Light/24/animations"
    ln -sf "../../${name}${theme}/24/actions" "${name}${theme}-Light/24/actions"
    ln -sf "../../${name}${theme}/24/places" "${name}${theme}-Light/24/places"
    ln -sf "../../${name}${theme}/24/devices" "${name}${theme}-Light/24/devices"
  else
    mkdir -p "${THEME_DIR}"/{16,22,24,32}

    cp -r "${SRC_DIR}"/src/16/{actions,places,devices} "${THEME_DIR}/16"
    cp -r "${SRC_DIR}"/src/22/{actions,places,devices} "${THEME_DIR}/22"
    cp -r "${SRC_DIR}"/src/24/{actions,places,devices} "${THEME_DIR}/24"
    cp -r "${SRC_DIR}"/src/32/actions "${THEME_DIR}/32"

    sed -i "s/#5d656b/#d3dae3/g" "${THEME_DIR}"/{16,22,24,32}/actions/*.svg
    sed -i "s/#5d656b/#d3dae3/g" "${THEME_DIR}"/{16,22,24}/places/*.svg
    sed -i "s/#5d656b/#d3dae3/g" "${THEME_DIR}"/{16,22,24}/devices/*.svg

    cp -r "${SRC_DIR}"/links/16/{actions,places,devices} "${THEME_DIR}/16"
    cp -r "${SRC_DIR}"/links/22/{actions,places,devices} "${THEME_DIR}/22"
    cp -r "${SRC_DIR}"/links/24/{actions,places,devices} "${THEME_DIR}/24"
    cp -r "${SRC_DIR}"/links/32/actions "${THEME_DIR}/32"

    cd "${dest}" || exit 1
    ln -sf "../${name}${theme}/scalable" "${name}${theme}-Dark/scalable"
    ln -sf "../${name}${theme}/symbolic" "${name}${theme}-Dark/symbolic"
    ln -sf "../${name}${theme}/48" "${name}${theme}-Dark/48"
    ln -sf "../${name}${theme}/96" "${name}${theme}-Dark/96"
    ln -sf "../${name}${theme}/128" "${name}${theme}-Dark/128"
    ln -sf "../../${name}${theme}/16/apps" "${name}${theme}-Dark/16/apps"
    ln -sf "../../${name}${theme}/16/emblems" "${name}${theme}-Dark/16/emblems"
    ln -sf "../../${name}${theme}/16/mimetypes" "${name}${theme}-Dark/16/mimetypes"
    ln -sf "../../${name}${theme}/16/panel" "${name}${theme}-Dark/16/panel"
    ln -sf "../../${name}${theme}/16/status" "${name}${theme}-Dark/16/status"
    ln -sf "../../${name}${theme}/22/emblems" "${name}${theme}-Dark/22/emblems"
    ln -sf "../../${name}${theme}/22/mimetypes" "${name}${theme}-Dark/22/mimetypes"
    ln -sf "../../${name}${theme}/22/panel" "${name}${theme}-Dark/22/panel"
    ln -sf "../../${name}${theme}/24/animations" "${name}${theme}-Dark/24/animations"
    ln -sf "../../${name}${theme}/24/panel" "${name}${theme}-Dark/24/panel"
    ln -sf "../../${name}${theme}/32/apps" "${name}${theme}-Dark/32/apps"
    ln -sf "../../${name}${theme}/32/devices" "${name}${theme}-Dark/32/devices"
    ln -sf "../../${name}${theme}/32/places" "${name}${theme}-Dark/32/places"
    ln -sf "../../${name}${theme}/32/status" "${name}${theme}-Dark/32/status"
  fi

  cd "${THEME_DIR}" || exit
  ln -sf 16 16@2x
  ln -sf 22 22@2x
  ln -sf 24 24@2x
  ln -sf 32 32@2x
  ln -sf 48 48@2x
  ln -sf 96 96@2x
  ln -sf 128 128@2x
  ln -sf scalable scalable@2x

  if [[ "${noapp:-}" == 'true' ]]; then
    rm -rf "${THEME_DIR}/16/apps"
    rm -rf "${THEME_DIR}/32/apps"
    rm -rf "${THEME_DIR}/32/devices"
    rm -rf "${THEME_DIR}/48/apps"
    rm -rf "${THEME_DIR}/scalable/apps"
    rm -rf "${THEME_DIR}/scalable/devices"
    rm -rf "${THEME_DIR}/symbolic/apps"
  fi

  cd "${dest}" || exit
  gtk-update-icon-cache "${name}${theme}${color}"
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo "ERROR: Destination directory does not exist."
        exit 1
      fi
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift 1
            ;;
          manjaro)
            themes+=("${THEME_VARIANTS[1]}")
            shift 1
            ;;
          ubuntu)
            themes+=("${THEME_VARIANTS[2]}")
            shift 1
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift 1
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized theme variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -c|--color)
      shift
        for color in "${@}"; do
          case "${color}" in
            standard)
              colors+=("${COLOR_VARIANTS[0]}")
              shift 1
              ;;
            dark)
              colors+=("${COLOR_VARIANTS[1]}")
              shift 1
              ;;
            all)
              colors+=("${COLOR_VARIANTS[@]}")
              shift 1
              ;;
            -*|--*)
              break
              ;;
            *)
              echo "ERROR: Unrecognized color variant '$1'."
              echo "Try '$0 --help' for more information."
              exit 1
              ;;
            esac
        done
        ;;
    --noapp)
      noapp='true'
      echo "INFO: Use system app icons."
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

#for THEME in '' '-manjaro' '-ubuntu'; do
#  for COLOR in '' '-dark' '-light'; do
#    if [[ "${THEME}" != '' || "${COLOR}" != '' ]] && [[ -d "${DEST_DIR}/${THEME_NAME}${THEME}${COLOR}" ]]; then
#      rm -rf "${DEST_DIR}/${THEME_NAME}${THEME}${COLOR}"
#      echo -e "Remove old themes ${DEST_DIR}/${THEME_NAME}${THEME}${COLOR}..."
#    fi
#  done
#done

for theme in "${themes[@]-${THEME_VARIANTS[@]}}"; do
  for color in "${colors[@]-${COLOR_VARIANTS[@]}}"; do
    install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
  done
done


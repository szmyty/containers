#!/usr/bin/env bash
set -eu

npx serve --listen "${N64_PORT}" "${N64_HOME}"/app/Nintendo64

#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
svg="$root/glenn-cloud.svg"
html="$root/index.html"

fail() { echo "FAIL: $1" >&2; exit 1; }

grep -q 'viewBox="0 0 500 500"' "$svg" || fail "SVG must use a 500 × 500 viewBox"
! grep -Eq '<rect[^>]+(width="500"|width="100%")' "$svg" || fail "engraving SVG must have no background rectangle"
grep -q 'fill="#fff"' "$svg" || fail "engraving geometry must be white"
grep -q 'point-field' "$svg" || fail "point-density field is missing"
dot_count="$(grep -Eoc '<(circle|use)\b' "$svg")"
(( dot_count >= 70 )) || fail "expected at least 70 explicit point elements, found $dot_count"
grep -q 'font-weight="700"' "$svg" || fail "GLENN wordmark must use a substantial weight"
grep -q 'Glass Preview' "$html" || fail "glass-preview toggle is missing"
grep -q 'Engraving File' "$html" || fail "engraving-file toggle is missing"
grep -q 'download="glenn-cloud.svg"' "$html" || fail "SVG download control is missing"
grep -q 'Cormorant Garamond' "$html" || fail "premium display typography is missing"
grep -q 'Inter' "$html" || fail "premium UI typography is missing"

echo "PASS: engraving and preview meet structural requirements ($dot_count point elements)"

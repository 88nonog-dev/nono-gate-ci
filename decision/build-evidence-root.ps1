$ErrorActionPreference="Stop"

$files = @(
"C:\Users\hp\Desktop\end-to-go\nono-gate-ci\decision\decision.json",
"C:\Users\hp\Desktop\end-to-go\nono-gate-ci\decision\policy.json",
"C:\Users\hp\Desktop\end-to-go\nono-gate-ci\decision\security-consensus.json"
)

$hashes = @()

foreach ($f in $files) {
    if (!(Test-Path $f)) {
        throw "INPUT_MISSING:$f"
    }
    $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLower()
    $hashes += $h
}

$joined = ($hashes | Sort-Object) -join ""

$bytes = [System.Text.Encoding]::UTF8.GetBytes($joined)
$sha = [System.Security.Cryptography.SHA256]::Create()
$root = ($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""

$out = "C:\Users\hp\Desktop\end-to-go\nono-gate-ci\decision\EVIDENCE_ROOT_SHA256.txt"

Set-Content -LiteralPath $out -Value $root -Encoding UTF8

if (!(Test-Path $out)) {
    throw "EVIDENCE_ROOT_NOT_CREATED"
}

Write-Host "HASH_COMPUTED:EVIDENCE_ROOT"

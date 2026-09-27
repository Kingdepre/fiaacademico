$ErrorActionPreference = 'Stop'
$parts = 1..4 | ForEach-Object { Join-Path $PSScriptRoot ('FIA-Academico.zip.part{0:D2}' -f $_) }
foreach ($part in $parts) {
    if (!(Test-Path -LiteralPath $part)) { throw "Falta la parte: $part. Coloca las cuatro partes en esta carpeta." }
}
$target = Join-Path $PSScriptRoot 'FIA-Academico-completo.zip'
if (Test-Path -LiteralPath $target) { throw 'El ZIP completo ya existe. Muevelo o cambiale el nombre antes de volver a unir.' }
$output = [IO.File]::Open($target, [IO.FileMode]::CreateNew)
try {
    foreach ($part in $parts) {
        $inputFile = [IO.File]::OpenRead($part)
        try { $inputFile.CopyTo($output) } finally { $inputFile.Dispose() }
    }
} finally { $output.Dispose() }
$expected = '5F175CF615A6DF324E12B8EAE58F267A2A808D62892D301A018815CC3AFD3C62'
if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $expected) {
    throw 'La verificacion fallo. Descarga las cuatro partes originales otra vez.'
}
Write-Host 'Listo: FIA-Academico-completo.zip. Contenido identico al ZIP original.' -ForegroundColor Green

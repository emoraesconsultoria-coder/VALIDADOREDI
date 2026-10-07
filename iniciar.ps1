$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$portableNode = Join-Path $PSScriptRoot '.tools\node-v22.14.0-win-x64'
if (Test-Path (Join-Path $portableNode 'node.exe')) {
    $env:Path = "$portableNode;$env:Path"
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw 'Instale o Node.js 22 ou superior e execute este script novamente.'
}
if (-not (Test-Path (Join-Path $PSScriptRoot 'node_modules'))) {
    & npm.cmd ci
    if ($LASTEXITCODE -ne 0) { throw 'Não foi possível instalar as dependências.' }
}
& npm.cmd run dev -- --host 127.0.0.1

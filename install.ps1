<#
.SYNOPSIS
Instala ou atualiza o Harness num projeto.

.DESCRIPTION
Copia template/core (genérico) e template/project (do projeto) para a pasta alvo.
- Arquivo que não existe: criado.
- template/project que já existe: mantido sempre (é do projeto).
- template/core que já existe e difere: mantido, a menos que -Update seja passado.

.EXAMPLE
pwsh ./install.ps1 -Target C:\projetos\meu-app -WhatIf

.EXAMPLE
pwsh ./install.ps1 -Target C:\projetos\meu-app -Update
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    # Pasta raiz do projeto que recebe o Harness.
    [Parameter(Mandatory)]
    [string] $Target,

    # Sobrescreve os arquivos de template/core que diferem.
    [switch] $Update
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Target -PathType Container)) {
    throw "Pasta alvo não existe: $Target"
}
$Target = (Resolve-Path -LiteralPath $Target).Path
$templateRoot = Join-Path $PSScriptRoot 'template'
if ($Target -eq $PSScriptRoot) {
    throw 'O alvo não pode ser o próprio Harness.'
}

function Get-Plan([string] $layer, [bool] $overwrite) {
    $source = Join-Path $templateRoot $layer
    foreach ($file in Get-ChildItem -LiteralPath $source -Recurse -File -Force) {
        $relative = [IO.Path]::GetRelativePath($source, $file.FullName)
        $dest = Join-Path $Target $relative
        $action = if (-not (Test-Path -LiteralPath $dest)) {
            'criar'
        } elseif ((Get-FileHash -LiteralPath $dest).Hash -eq (Get-FileHash -LiteralPath $file.FullName).Hash) {
            'igual'
        } elseif ($overwrite) {
            'atualizar'
        } elseif ($layer -eq 'core') {
            'difere'
        } else {
            'manter'
        }
        [pscustomobject]@{ Camada = $layer; Arquivo = $relative; Acao = $action; Origem = $file.FullName; Destino = $dest }
    }
}

$plan = @(Get-Plan 'core' $Update.IsPresent) + @(Get-Plan 'project' $false)

foreach ($item in $plan | Where-Object { $_.Acao -in 'criar', 'atualizar' }) {
    if ($PSCmdlet.ShouldProcess($item.Destino, $item.Acao)) {
        $dir = Split-Path -Parent $item.Destino
        if (-not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Path $dir | Out-Null
        }
        Copy-Item -LiteralPath $item.Origem -Destination $item.Destino -Force
    }
}

$plan | Sort-Object Camada, Arquivo | Format-Table Camada, Acao, Arquivo -AutoSize

$different = @($plan | Where-Object Acao -eq 'difere')
if ($different.Count -gt 0) {
    Write-Warning "$($different.Count) arquivo(s) do core diferem do Harness e foram mantidos. Confira o diff e rode com -Update para sobrescrever."
}
if (-not $WhatIfPreference -and @($plan | Where-Object { $_.Camada -eq 'project' -and $_.Acao -eq 'criar' }).Count -gt 0) {
    Write-Host 'Arquivos do projeto criados com marcadores <...>. Use o "Prompt de adoção" do README do Harness para preenchê-los.'
}

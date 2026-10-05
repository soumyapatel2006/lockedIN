<#
.SYNOPSIS
  Automated Milestone 1 Verification Script for LockedIN.
.DESCRIPTION
  Validates environment tooling, R3 layout compliance, code constraints,
  npm build execution, and Vite dist asset emission.
.NOTES
  Workspace: c:\Users\Windows-10\Desktop\Antigravity projects\locked IN
#>

[CmdletBinding()]
param (
  [string]$ProjectRoot = "c:\Users\Windows-10\Desktop\Antigravity projects\locked IN",
  [switch]$SkipBuildExecution = $false
)

$ErrorActionPreference = "Stop"
$failures = @()
$passedChecks = 0

function Report-Pass($msg) {
  Write-Host "  [PASS] $msg" -ForegroundColor Green
  $script:passedChecks++
}

function Report-Fail($msg) {
  Write-Host "  [FAIL] $msg" -ForegroundColor Red
  $script:failures += $msg
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " LockedIN — Milestone 1 Build & Layout Verification Suite " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Target: $ProjectRoot`n"

# ---------------------------------------------------------
# Phase 1: Tooling & Runtime Prerequisite Check
# ---------------------------------------------------------
Write-Host "[1/5] Checking Tooling Prerequisites..." -ForegroundColor Yellow

$nodeDir = "$env:USERPROFILE\.local\node"
if (Test-Path $nodeDir) {
  if ($env:PATH -notlike "*$nodeDir*") {
    $env:PATH = "$nodeDir;$env:PATH"
  }
}

$nodeCmd = Get-Command "node" -ErrorAction SilentlyContinue
$npmCmd = Get-Command "npm.cmd" -ErrorAction SilentlyContinue
if (-not $npmCmd) { $npmCmd = Get-Command "npm" -ErrorAction SilentlyContinue }

if ($nodeCmd) {
  $nodeVer = & node -v
  Report-Pass "Node.js detected: $nodeVer ($($nodeCmd.Source))"
} else {
  Report-Fail "Node.js is not found in PATH. Install Node.js LTS v20.x before running build."
}

if ($npmCmd) {
  $npmVer = & npm.cmd -v 2>$null
  if (-not $npmVer) { $npmVer = & npm -v 2>$null }
  Report-Pass "npm detected: $npmVer ($($npmCmd.Source))"
} else {
  Report-Fail "npm is not found in PATH."
}

# ---------------------------------------------------------
# Phase 2: Configuration & Essential Files Check
# ---------------------------------------------------------
Write-Host "`n[2/5] Validating Root Configurations..." -ForegroundColor Yellow

$requiredConfigs = @(
  "package.json",
  "vite.config.js",
  "tailwind.config.js",
  "postcss.config.js",
  "index.html",
  "src/index.css",
  "src/main.jsx",
  "src/App.jsx",
  "src/utils/cn.js"
)

foreach ($file in $requiredConfigs) {
  $fullPath = Join-Path $ProjectRoot $file
  if (Test-Path $fullPath -PathType Leaf) {
    Report-Pass "Config exists: $file"
  } else {
    Report-Fail "Missing required file: $file"
  }
}

# ---------------------------------------------------------
# Phase 3: R3 Architecture & Directory Layout Compliance
# ---------------------------------------------------------
Write-Host "`n[3/5] Verifying R3 Directory Layout Compliance..." -ForegroundColor Yellow

$requiredDirs = @(
  "src/components/layout",
  "src/components/dashboard",
  "src/components/tasks",
  "src/components/calendar",
  "src/components/graphs",
  "src/components/challenges",
  "src/components/focus",
  "src/components/goals",
  "src/components/history",
  "src/components/reflection",
  "src/components/ui",
  "src/pages",
  "src/data",
  "src/utils",
  "src/services"
)

foreach ($relDir in $requiredDirs) {
  $fullDir = Join-Path $ProjectRoot $relDir
  if (Test-Path $fullDir -PathType Container) {
    Report-Pass "R3 Directory present: $relDir"
  } else {
    Report-Fail "Missing required R3 directory: $relDir"
  }
}

# ---------------------------------------------------------
# Phase 4: Code Quality & Architectural Integrity Checks
# ---------------------------------------------------------
Write-Host "`n[4/5] Running Architectural Guardrail Checks..." -ForegroundColor Yellow

$srcPath = Join-Path $ProjectRoot "src"
if (Test-Path $srcPath) {
  # 4.1 Check direct localStorage access in components/pages (R4 violation)
  $compPath = Join-Path $srcPath "components"
  $pagesPath = Join-Path $srcPath "pages"
  $violations = @()

  if (Test-Path $compPath) {
    $matches = Get-ChildItem -Path $compPath -Recurse -Filter *.jsx -ErrorAction SilentlyContinue |
      Select-String -Pattern "localStorage" -SimpleMatch
    if ($matches) { $violations += $matches }
  }
  if (Test-Path $pagesPath) {
    $matches = Get-ChildItem -Path $pagesPath -Recurse -Filter *.jsx -ErrorAction SilentlyContinue |
      Select-String -Pattern "localStorage" -SimpleMatch
    if ($matches) { $violations += $matches }
  }

  if ($violations.Count -eq 0) {
    Report-Pass "R4 Adherence: 0 direct localStorage calls in components or pages."
  } else {
    Report-Fail "R4 Violation: $($violations.Count) direct localStorage calls found outside services/storageService.js."
  }

  # 4.2 Check file length limit (< 300 lines)
  $longFiles = @()
  $codeFiles = Get-ChildItem -Path $srcPath -Recurse -Include *.jsx,*.js -ErrorAction SilentlyContinue
  foreach ($cf in $codeFiles) {
    $lineCount = (Get-Content $cf.FullName | Measure-Object -Line).Lines
    if ($lineCount -gt 300) {
      $longFiles += "$($cf.Name) ($lineCount lines)"
    }
  }

  if ($longFiles.Count -eq 0) {
    Report-Pass "LOC Adherence: All source files are strictly < 300 lines."
  } else {
    Report-Fail "LOC Violation: Files exceed 300 lines: $($longFiles -join ', ')"
  }
} else {
  Report-Fail "Source folder src/ does not exist."
}

# ---------------------------------------------------------
# Phase 5: Build Execution & Dist Asset Validation
# ---------------------------------------------------------
Write-Host "`n[5/5] Inspecting Build Output and Dist Assets..." -ForegroundColor Yellow

if ($SkipBuildExecution) {
  Write-Host "  [SKIP] Build execution skipped by parameter." -ForegroundColor Gray
} elseif (-not $nodeCmd -or -not $npmCmd) {
  Report-Fail "Cannot execute build because Node.js / npm is not available in PATH."
} else {
  Set-Location $ProjectRoot
  Write-Host "  Executing: npm.cmd run build..." -ForegroundColor Cyan
  
  $buildOutput = & npm.cmd run build 2>&1
  if ($LASTEXITCODE -eq 0) {
    Report-Pass "Vite production build passed cleanly (exit code 0)."
  } else {
    Report-Fail "Vite production build failed with exit code $LASTEXITCODE. Output: `n$buildOutput"
  }

  # Validate dist directory
  $distPath = Join-Path $ProjectRoot "dist"
  $distIndex = Join-Path $distPath "index.html"
  $distAssets = Join-Path $distPath "assets"

  if (Test-Path $distIndex -PathType Leaf) {
    $indexSize = (Get-Item $distIndex).Length
    if ($indexSize -gt 200) {
      Report-Pass "dist/index.html emitted ($indexSize bytes)."
    } else {
      Report-Fail "dist/index.html is suspiciously small ($indexSize bytes)."
    }

    # Verify script and style tags injected
    $indexContent = Get-Content $distIndex -Raw
    if ($indexContent -match '<script[^>]+src=["''](/assets/[^"'']+\.js)["'']') {
      Report-Pass "Injected JS script tag detected in dist/index.html: $($Matches[1])"
    } else {
      Report-Fail "No valid script tag found in dist/index.html"
    }

    if ($indexContent -match '<link[^>]+href=["''](/assets/[^"'']+\.css)["'']') {
      Report-Pass "Injected CSS link tag detected in dist/index.html: $($Matches[1])"
    } else {
      Report-Fail "No valid stylesheet link tag found in dist/index.html"
    }
  } else {
    Report-Fail "dist/index.html was not emitted."
  }

  if (Test-Path $distAssets -PathType Container) {
    $jsAssets = Get-ChildItem -Path $distAssets -Filter *.js
    $cssAssets = Get-ChildItem -Path $distAssets -Filter *.css

    if ($jsAssets.Count -gt 0) {
      Report-Pass "Found $($jsAssets.Count) JavaScript asset bundle(s) in dist/assets/."
    } else {
      Report-Fail "No JavaScript asset bundles found in dist/assets/."
    }

    if ($cssAssets.Count -gt 0) {
      Report-Pass "Found $($cssAssets.Count) CSS asset bundle(s) in dist/assets/."

      # Verify Tailwind compiled properly (no unparsed @tailwind directives)
      foreach ($cssFile in $cssAssets) {
        $rawCss = Get-Content $cssFile.FullName -Raw
        if ($rawCss -match "@tailwind") {
          Report-Fail "Unparsed @tailwind directive detected in emitted CSS: $($cssFile.Name)!"
        } else {
          Report-Pass "Emitted CSS $($cssFile.Name) properly compiled ($($cssFile.Length) bytes)."
        }
      }
    } else {
      Report-Fail "No CSS asset bundles found in dist/assets/."
    }
  } else {
    Report-Fail "dist/assets/ directory was not emitted."
  }
}

# ---------------------------------------------------------
# Summary Report
# ---------------------------------------------------------
Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " Verification Summary" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Total Passed Checks: $passedChecks" -ForegroundColor Green

if ($failures.Count -eq 0) {
  Write-Host "Result: ALL VERIFICATION CHECKS PASSED!" -ForegroundColor Green
  exit 0
} else {
  Write-Host "Result: $($failures.Count) VERIFICATION CHECK(S) FAILED:" -ForegroundColor Red
  foreach ($f in $failures) {
    Write-Host "  - $f" -ForegroundColor Red
  }
  exit 1
}

param(
    [string]$Java = "${env:JAVA_HOME}\bin\java.exe",
    [string]$PlantUmlJar = "C:\ProgramData\chocolatey\lib\plantuml\tools\plantuml.jar",
    [string]$Inkscape = "C:\Program Files\Inkscape\bin\inkscape.exe",
    [string]$SourcesFiles = (Join-Path $PSScriptRoot "img/sc10-cloud-archictecture"),
    [string]$PngImagesFolder = (Join-Path $PSScriptRoot "img/sc10-cloud-archictecture"),
    [string]$SpritesFolder = (Join-Path $PSScriptRoot "sprites"),
    [string]$SpriteColor = "SITECORE_COLOR",
    [string]$ThemeName = "Sitecore Cloud",
    [string]$ThemeDescription = "Icons for Sitecore related services",
    [Switch]$SkipFetchImages,
    [Switch]$SkipStructurizrTheme,
    [Switch]$SkipSprites,
    [Switch]$SkipAllPuml
)

$ErrorActionPreference = "STOP"

if (-not $SkipFetchImages) {
    $data = Get-Content (join-path $SourcesFiles "icons.json" -Resolve) | ConvertFrom-Json
    foreach ($key in $data.icons.PSObject.Properties.Name) {
        Write-Host "Fetching $key"
        $cfg = $data.icons.$key
        $extension = $cfg.type ?? $data.defaults.type
        $outPath = Join-Path $SourcesFiles "${key}.${extension}"
        Invoke-WebRequest -UseBasicParsing -Uri $cfg.src -OutFile $outPath

        if ($extension -eq "svg") {
            $outPngPath = Join-Path $SourcesFiles "${key}.png"
            $out64Png = Join-Path $SourcesFiles "${key}_64.png"

            Invoke-Expression "& `"$Inkscape`" --export-type=`"png`" --export-area-page --export-filename=`"$outPngPath`" --export-height=200 --export-overwrite $outPath"
            Invoke-Expression "& `"$Inkscape`" --export-type=`"png`" --export-area-page --export-filename=`"$out64Png`" --export-height=64 --export-overwrite $outPath"
        }
    }
}

if(-not $SkipStructurizrTheme) {
    $data = Get-Content (join-path $SourcesFiles "icons.json" -Resolve) | ConvertFrom-Json
    $elements = @()
    foreach ($key in $data.icons.PSObject.Properties.Name) {
        $cfg = $data.icons.$key
        $extension = $cfg.type ?? $data.defaults.type

        $elements += @{
            tag = $cfg.tag ?? $key
            icon = "${key}.${extension}"
        }
    }

    @{
        name = $ThemeName
        description = $ThemeDescription
        elements = $elements
    } | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $SourcesFiles "structurizr-theme.json")
}

if(-not $SkipSprites -and -not (Test-Path $PlantUmlJar -PathType Leaf)) {
    Write-Warning "Skip sprites as PlantUML was not found"
    $SkipSprites = $true
}
if (-not $SkipSprites) {

    if(-not $SkipFetchImages) {
        Write-Host "Wait a moment for disk updates..."
        Start-Sleep -Seconds 2
    }

    Write-Host "Generate pngs for sprites"
    $svgs = Get-ChildItem -Path $SourcesFiles -Filter *.svg
    foreach($svg in $svgs) {
        $key = $svg.BaseName
        $svgPath = $svg.FullName
        $outSprite = Join-Path $SourcesFiles "sitecore_${key}.png"
        Invoke-Expression "& `"$Inkscape`" --export-type=`"png`" --export-area-page --export-filename=`"$outSprite`" --export-height=64 --export-background=white --export-overwrite $svgPath"
    }    
    Start-Sleep -Seconds 2

    Write-Host "Creating sprites for PlantUML"
    If (-not (Test-Path $SpritesFolder)) {
        New-Item $SpritesFolder -ItemType Directory | Out-Null
    }
    
    $items = Get-ChildItem $PngImagesFolder -Recurse -Filter "sitecore_*.png"
    foreach($itm in $items) {
        $imgPath = $itm.FullName
        $sprite = ((& $Java -jar $PlantUmlJar -encodesprite 16 $imgPath) -join "`n").Replace("_64 [", " [")

        $name = $itm.BaseName
        $spritename = $name
        $entity = $name.ToUpperInvariant().Replace(" ", "_")
        
        $stereoType = "Sitecore"
        $puml_short = "!define ${entity}(e_alias, e_label, e_techn) SC_ENTITY(e_alias, e_label, e_techn, `"`", SITECORE_SYMBOL_COLOR, ${spritename}, ${stereoType})"
        $puml_long = "!define ${entity}(e_alias, e_label, e_techn, e_descr) SC_ENTITY(e_alias, e_label, e_techn, e_descr, SITECORE_SYMBOL_COLOR, ${spritename}, ${stereoType})"
        $content = "${sprite}`n`n${puml_short}`n${puml_long}`n"
        Set-Content -Path (Join-Path $SpritesFolder ("{0}.puml" -f $name.Replace("sitecore_", ""))) -Value $content

        Remove-item $itm.FullName
    }
}

If (-not $SkipAllPuml) {
    Write-Host "Creating all.puml"
    $allContent = ""
    if(Test-Path (Join-Path $SpritesFolder "common.puml")) {
        $allContent = Get-Content (Join-Path $SpritesFolder "common.puml") -Raw
    }

    Get-ChildItem $SpritesFolder -Filter *.puml | ForEach-Object {
        $name = $_.BaseName
        if ($name -ne "common" -and $name -ne "all") {
            $content = Get-Content $_.FullName -Raw
            $allContent += "`n`n'${name}.puml`n${content}"
        }
    }
    Set-Content -Path (Join-Path $SpritesFolder "all.puml") -Value $allContent
}
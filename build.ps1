param(
    [string]$PlantUmlJar = "C:\ProgramData\chocolatey\lib\plantuml\tools\plantuml.jar",
    [string]$ImagesFolder = (Join-Path $PSScriptRoot "img"),
    [string]$TargetFolder = (Join-Path $PSScriptRoot "sprites"),
    [string]$Java = "${env:JAVA_HOME}\bin\java.exe",
    [string]$SpriteColor = "#00484E"
)

$ErrorActionPreference = "STOP"

If(-not (Test-Path $TargetFolder)) {
    New-Item $TargetFolder -ItemType Directory | Out-Null
}

Get-ChildItem $ImagesFolder -Recurse -Filter "*.png" | ForEach-Object {
    $path = $_.FullName
    $sprite = (& $Java -jar $PlantUmlJar -encodesprite 8 $path) -join "`n"

    $spritename = $_.BaseName
    $name = $_.BaseName
    $entity = $name.ToUpperInvariant()
    
    $puml_short = "!define ${entity}(alias) PUML_ENTITY(component,${SpriteColor},${name},alias,${spritename})"
    $puml_long  = "!definelong ${entity}(alias,label,e_type=`"component`",e_color=`"${SpriteColor}`",e_stereo=`"Sitecore`",e_sprite=`"${spritename}`")`nPUML_ENTITY(e_type,e_color,e_sprite,label,alias,e_stereo)`n!enddefinelong"
    $content = "${sprite}`n`n${puml_short}`n`n${puml_long}"
    Set-Content -Path (Join-Path $TargetFolder "${name}.puml") -Value $content
}

$allContent = Get-Content (Join-Path $TargetFolder "common.puml") -Raw
Get-ChildItem $TargetFolder -Filter *.puml | ForEach-Object {
    $name = $_.BaseName
    if($name -ne "common" -and $name -ne "all") {
        $content = Get-Content $_.FullName -Raw
        $allContent += "`n`n'${name}.puml`n${content}"
    }
}
Set-Content -Path (Join-Path $TargetFolder "all.puml") -Value $allContent
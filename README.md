# Sitecore icon set for PlantUML

I like to make my architecture diagrams in [PlantUML](http://plantuml.com/) and have them in source control.

Inspired by [plantuml-icon-font-sprites](https://github.com/tupadr3/plantuml-icon-font-sprites), I copied the icons from Sitecore documentation and made sprites, so they can easily be used in diagrams.

## How to use

```
!define SC_SPRITESPATH https://raw.githubusercontent.com/jballe/plantuml-sitecore-icons/master/sprites
!includeurl SC_SPRITESPATH/common.puml
!includeurl SC_SPRITESPATH/scWeb.puml

SCWEB(cm, "Content\nManagement")
```

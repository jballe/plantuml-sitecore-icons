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

Will give you

![small](https://www.plantuml.com/plantuml/png/0/TOx12e9054NtWlzWhWhIsRUgHAX582cu2M8SNpenyvHvR-Ztcx1LqEvoEPnxzyJIiRScZbOzF3H2KXVtkhgUcxAk3iqf6PbdsWdXv2iVD8--ymHEJSY0dAl9YcSdZG4n6uaVKqQQGKqECXqe4bOIWnCqkz1JsD6eZE_1E_Ep9OBDJfZFov__7AaMkYyMHtNHbiUrijiaBPPRDxn8b0FOaDDD7Eq1-m2_0G00 "small")
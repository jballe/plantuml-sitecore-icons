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

![frontpage.puml](http://www.plantuml.com/plantuml/proxy?src=https://raw.github.com/jballe/plantuml-sitecore-icons/master/samples/frontpage.puml)

You can embed diagrams from public sources by using plantuml as above. For private repos I often generate an image url with the source embedded, like when using [PlantText.com](https://www.planttext.com/?text=TOx12e9054NtWlzWhWhIsRUgHAX582cu2M8SNpenyvHvR-Ztcx1LqEvoEPnxzyJIiRScZbOzF3H2KXVtkhgUcxAk3iqf6PbdsWdXv2iVD8--ymHEJSY0dAl9YcSdZG4n6uaVKqQQGKqECXqe4bOIWnCqkz1JsD6eZE_1E_Ep9OBDJfZFov__7AaMkYyMHtNHbiUrijiaBPPRDxn8b0FOaDDD7Eq1-m2_0G00)

I can also recommend the [VS Code extension for PlantUML](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)
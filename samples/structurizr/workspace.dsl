workspace "Sitecore example" {
    model {
        v = person "Visitor"
        e = person "Editor"

        ss = softwareSystem "Software System" {
            web = container "Website" {
                tag "Microsoft Azure - App Services"
            }
            portal = container "Portal" {
                tag "Microsoft Azure - App Services"
            }
            scai = container "SitecoreAI" {
                tag "SitecoreAI"
            }

            web -> scai "Fetches layouts"
            portal -> scai "Fetches content"
        }

        v -> web "Uses"
        v -> portal "Uses"

        e -> web "Edit content"
        e -> scai "Edit content"
    }

    views {
        systemContext ss "ContextDiagram" {
            include *
            autolayout lr
        }

        container ss "ContainerDiagram" {
            include *
            autolayout lr
        }

        theme "https://static.structurizr.com/themes/microsoft-azure-2024.07.15/icons.json"

        theme "https://raw.githubusercontent.com/jballe/plantuml-sitecore-icons/refs/tags/v2025.1/sprites/structurizr-theme.json"
    }
}


## Power BI

### Sources

CI_CategoryInstances

This provides the raw data for all of the CI categories in the database

```sql
let
    Source = Sql.Database("v0002ws0133", "CM_VR1"),
    dbo_CI_CategoryInstances = Source{[Schema="dbo",Item="CI_CategoryInstances"]}[Data]
in
    dbo_CI_CategoryInstances
```

CI_LocalizedCategoryInstances

This, when joined to the above data, will provide the localized name of the CI Category.

```sql
let
    Source = Sql.Database("v0002ws0133", "CM_VR1"),
    dbo_CI_LocalizedCategoryInstances = Source{[Schema="dbo",Item="CI_LocalizedCategoryInstances"]}[Data]
in
    dbo_CI_LocalizedCategoryInstances
```
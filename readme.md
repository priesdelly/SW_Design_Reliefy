# Reliefy

Appointment system

## Backend
### Installation

.Net 7

Setup credential file by copying from

```
Reliefy.UI/appsettings.Development.json.example 
```
to
```
Reliefy.UI/appsettings.{env}.json 
```
change ```{env}``` follow running ```ASPNETCORE_ENVIRONMENT``` and replace <<ConnectionStrings:Reliefy>> with your connection string

Remark ``` protect upload credentials data to git``` need to skip upload some *appsettings.json* file to git and just use only in local of the dev environment

----

Data migration when entities changed replace <<MigrationName>> with name of migration
```bash
dotnet ef migrations add <<MigrationName>> --project Reliefy.Infrastructure --startup-project Reliefy.UI -o Persistence/Migrations
```

Update database
```bash
dotnet ef database update --project Reliefy.Infrastructure --startup-project Reliefy.UI
```

## Mobile
### Installation

Flutter version 3

Run this command after add model
```
flutter pub run build_runner build
```

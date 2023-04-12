# Reliefy

Appointment system

## Backend
### Installation

.Net 7

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

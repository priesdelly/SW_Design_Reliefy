# Reliefy

Appointment system

## Installation

.Net 7

Data migration when entities changed replace <<MigrationName>> with name of migration
```bash
dotnet ef migrations add <<MigrationName>> --project Reliefy.Infrastructure --startup-project Reliefy.UI -o Persistence/Migrations
```

Update database
```bash
dotnet ef database update --project Reliefy.Infrastructure --startup-project Reliefy.UI
```
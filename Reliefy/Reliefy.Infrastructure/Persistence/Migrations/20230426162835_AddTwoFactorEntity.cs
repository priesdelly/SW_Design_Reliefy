using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Reliefy.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddTwoFactorEntity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "TwoFactor",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Email = table.Column<string>(type: "character varying", maxLength: 200, nullable: false),
                    Code = table.Column<string>(type: "character varying", maxLength: 6, nullable: false),
                    IsUsed = table.Column<bool>(type: "boolean", nullable: false),
                    ExpireAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TwoFactor", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_TwoFactor_Email_Code",
                table: "TwoFactor",
                columns: new[] { "Email", "Code" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TwoFactor");
        }
    }
}

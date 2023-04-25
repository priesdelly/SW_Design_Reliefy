using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Reliefy.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddScoreFieldAppointmentTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Score",
                table: "Appointments",
                type: "integer",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Score",
                table: "Appointments");
        }
    }
}

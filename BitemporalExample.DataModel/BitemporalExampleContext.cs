using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace BitemporalExample.DataModel
{
    public partial class BitemporalExampleContext : DbContext
    {
        public BitemporalExampleContext()
        {
        }

        public BitemporalExampleContext(DbContextOptions<BitemporalExampleContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Employee> Employee { get; set; }
        public virtual DbSet<HourlyRate> HourlyRate { get; set; }
        public virtual DbSet<WorkLog> WorkLog { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer("Server=localhost;Database=BitemporalExample;Trusted_Connection=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Employee>(entity =>
            {
                entity.Property(e => e.Position).IsUnicode(false);
            });

            modelBuilder.Entity<HourlyRate>(entity =>
            {
                entity.HasOne(d => d.Employee)
                    .WithMany(p => p.HourlyRate)
                    .HasForeignKey(d => d.EmployeeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__HourlyRat__Emplo__3A81B327");
            });

            modelBuilder.Entity<WorkLog>(entity =>
            {
                entity.HasOne(d => d.Employee)
                    .WithMany(p => p.WorkLog)
                    .HasForeignKey(d => d.EmployeeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__WorkLog__Employe__3E52440B");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}

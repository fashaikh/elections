namespace ElectionData.Models
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class ElectionData : DbContext
    {
        public ElectionData()
            : base("name=ElectionData")
        {
        }

        public virtual DbSet<County> Counties { get; set; }
        public virtual DbSet<Precinct> Precincts { get; set; }
        public virtual DbSet<Result> Results { get; set; }
        public virtual DbSet<VoteOption> VoteOptions { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<County>()
                .Property(e => e.Turnout)
                .HasPrecision(5, 2);

            modelBuilder.Entity<Result>()
                .Property(e => e.ResultType)
                .IsUnicode(false);

            modelBuilder.Entity<VoteOption>()
                .Property(e => e.Jurisdiction)
                .IsUnicode(false);

            modelBuilder.Entity<VoteOption>()
                .Property(e => e.Party)
                .IsUnicode(false);
        }
    }
}

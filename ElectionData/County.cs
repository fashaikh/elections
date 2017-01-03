namespace ElectionData.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("County")]
    public partial class County
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int CountyId { get; set; }

        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string CountyCode { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(200)]
        public string State { get; set; }

        [Required]
        [StringLength(300)]
        public string CountyName { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime Created { get; set; }

        public int BallotsCounted { get; set; }

        public decimal Turnout { get; set; }

        public int RegisteredVoters { get; set; }
    }
}

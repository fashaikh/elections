namespace ElectionData.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("VoteOption")]
    public partial class VoteOption
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int VoteOptionId { get; set; }

        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string ElectionCycle { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(300)]
        public string Race { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(100)]
        public string Candidate { get; set; }

        [StringLength(300)]
        public string Jurisdiction { get; set; }

        [StringLength(300)]
        public string Party { get; set; }
    }
}

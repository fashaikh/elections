namespace ElectionData.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Result")]
    public partial class Result
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ResultId { get; set; }

        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int PrecinctId { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int VoteOptionId { get; set; }

        public int Count { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime Created { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime ResultsUntil { get; set; }

        [Required]
        [StringLength(10)]
        public string ResultType { get; set; }
    }
}

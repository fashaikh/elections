namespace ElectionData.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Precinct")]
    public partial class Precinct
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int PrecinctId { get; set; }

        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int CountyId { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int PrecinctCode { get; set; }

        [Required]
        [StringLength(300)]
        public string PrecinctName { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime Created { get; set; }
    }
}

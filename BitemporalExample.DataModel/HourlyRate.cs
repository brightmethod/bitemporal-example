using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BitemporalExample.DataModel
{
    public partial class HourlyRate
    {
        [Key]
        [Column("HourlyRateID")]
        public int HourlyRateId { get; set; }
        [Column("EmployeeID")]
        public int EmployeeId { get; set; }
        [Column("HourlyRate", TypeName = "decimal(10, 2)")]
        public decimal HourlyRate1 { get; set; }
        public DateTime EffectiveFrom { get; set; }
        public DateTime EffectiveTo { get; set; }
        public DateTime SysStart { get; set; }
        public DateTime SysEnd { get; set; }

        [ForeignKey(nameof(EmployeeId))]
        [InverseProperty("HourlyRate")]
        public virtual Employee Employee { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BitemporalExample.DataModel
{
    public partial class WorkLog
    {
        [Key]
        [Column("WorkLogID")]
        public int WorkLogId { get; set; }
        [Column("EmployeeID")]
        public int EmployeeId { get; set; }
        public DateTime WorkDate { get; set; }
        public int MinutesWorked { get; set; }
        public DateTime SysStart { get; set; }
        public DateTime SysEnd { get; set; }

        [ForeignKey(nameof(EmployeeId))]
        [InverseProperty("WorkLog")]
        public virtual Employee Employee { get; set; }
    }
}

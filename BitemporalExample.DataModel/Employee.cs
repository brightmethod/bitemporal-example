using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BitemporalExample.DataModel
{
    public partial class Employee
    {
        public Employee()
        {
            HourlyRate = new HashSet<HourlyRate>();
            WorkLog = new HashSet<WorkLog>();
        }

        [Key]
        [Column("EmployeeID")]
        public int EmployeeId { get; set; }
        [Required]
        [StringLength(100)]
        public string Name { get; set; }
        [Required]
        [StringLength(100)]
        public string Position { get; set; }
        public DateTime SysStart { get; set; }
        public DateTime SysEnd { get; set; }

        [InverseProperty("Employee")]
        public virtual ICollection<HourlyRate> HourlyRate { get; set; }
        [InverseProperty("Employee")]
        public virtual ICollection<WorkLog> WorkLog { get; set; }
    }
}

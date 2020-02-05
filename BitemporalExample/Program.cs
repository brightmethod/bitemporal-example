using BitemporalExample.DataModel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;

namespace BitemporalExample
{
    class Program
    {
        static void Main(string[] args)
        {
            DisplayNormal();
            DisplayBitemporal();
        }

        private static void DisplayNormal()
        {
            BitemporalExampleContext dbContext = new BitemporalExampleContext();
            var hourlyRates = dbContext.HourlyRate
                                       .Include(n => n.Employee)
                                       .OrderBy(n => n.Employee.Name)
                                       .ToList();

            Console.WriteLine("Normal");
            Console.WriteLine("-----");

            foreach (var item in hourlyRates)
            {
                Console.WriteLine("Name: " + item.Employee.Name);
                Console.WriteLine("Hourly Rate: " + item.HourlyRate1.ToString());
                Console.WriteLine("Effective From: " + item.EffectiveFrom.ToShortDateString());
                Console.WriteLine("Effective To: " + item.EffectiveTo.ToShortDateString());
                Console.WriteLine("");
            }
        }

        private static void DisplayBitemporal()
        {
            BitemporalExampleContext dbContext = new BitemporalExampleContext();
            var asAtDate = new DateTime(2020, 2, 5, 10, 34, 0);
            var hourlyRates = dbContext.HourlyRate
                                       .FromSqlRaw($"SELECT * FROM dbo.HourlyRate FOR SYSTEM_TIME AS OF {{0}}", asAtDate)
                                       .Include(n => n.Employee)
                                       .AsNoTracking()
                                       .OrderBy(n => n.Employee.Name)
                                       .ToList();

            Console.WriteLine("Bitemporal");
            Console.WriteLine("-----");

            foreach (var item in hourlyRates)
            {
                Console.WriteLine("Name: " + item.Employee.Name);
                Console.WriteLine("Hourly Rate: " + item.HourlyRate1.ToString());
                Console.WriteLine("Effective From: " + item.EffectiveFrom.ToShortDateString());
                Console.WriteLine("Effective To: " + item.EffectiveTo.ToShortDateString());
                Console.WriteLine("");
            }
        }
    }
}

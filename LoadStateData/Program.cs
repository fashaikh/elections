using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using ElectionData.Models;
using HtmlAgilityPack;
using System.Diagnostics;
using System.IO;
using System.Linq.Expressions;
using Microsoft.VisualBasic.FileIO;

namespace LoadStateData
{
    /// <summary>
    /// Helper methods for the lists.
    /// </summary>
    public static class ListExtensions
    {
        public static List<List<T>> ChunkBy<T>(this List<T> source, int chunkSize)
        {
            return source
                .Select((x, i) => new { Index = i, Value = x })
                .GroupBy(x => x.Index / chunkSize)
                .Select(x => x.Select(v => v.Value).ToList())
                .ToList();
        }
    }

    static class Program
    {
        private static string ElectionCycle = "20161108";
        static void Main(string[] args)
        {
            //ScrapeCountyData().GetAwaiter().GetResult();
            //ScrapePrecinctDataSIngleThread(Int32.Parse(args[0]), Int32.Parse(args[1])).GetAwaiter().GetResult();
            //ScrapePrecinctDataFromMasterPreceinctCSV().GetAwaiter().GetResult();
            ScrapeCountyDataFromMasterCountyCSV().GetAwaiter().GetResult();
        }

        private static async Task ScrapeCountyDataFromMasterCountyCSV()
        {
            var a = new ElectionData.Models.ElectionData();
            a.Configuration.AutoDetectChangesEnabled = false;
            a.Configuration.ValidateOnSaveEnabled = false;

            try
            {

                using (var stream = new MemoryStream())
                {
                    var precinctResults = await Get(new UriBuilder(
                        $"http://results.vote.wa.gov/results/current/export/20161108_AllCounties.csv").Uri, 300);

                    IList<VoteOption> voteOptionList = await a.VoteOptions.ToListAsync();

                    var bytes = System.Text.Encoding.Default.GetBytes(precinctResults);
                    stream.Write(bytes, 0, bytes.Length);
                    var countyList = await a.Counties.ToListAsync();
                    var precinctList = await a.Precincts.ToListAsync();
                    IList<Result> resultsList = await a.Results.ToListAsync();
                    IList<Result> resultsListToAdd = new List<Result>();

                    stream.Seek(0, SeekOrigin.Begin);
                    var index = 0;
                    using (TextFieldParser parser = new TextFieldParser(stream))
                    {
                        parser.TextFieldType = FieldType.Delimited;
                        parser.SetDelimiters(",");
                        parser.ReadFields();//skip header
                        while (!parser.EndOfData)
                        {

                            //Processing row
                            string[] fields = parser.ReadFields();
                            var race = fields[0];
                            var countycode = fields[1];
                            var candidate = fields[2];
                            var precinctname = fields[3];
                            var precinctcode = Int32.Parse(fields[4]);
                            var count = Int32.Parse(fields[5]);
                            if (precinctname != "Total")
                            {
                                Console.WriteLine($"Record: {index++}");
                                var countyid =
                                    countyList
                                        .FirstOrDefault(b => b.CountyCode == countycode && b.State == "WA")
                                        .CountyId;
                                var precinctId =
                                    precinctList
                                    .FirstOrDefault(b => b.CountyId == countyid && b.PrecinctCode == precinctcode)
                                    .PrecinctId;
                                var voteoptionid =
                                        voteOptionList
                                        .FirstOrDefault(b => b.Candidate == candidate && b.Race == race && b.ElectionCycle == ElectionCycle)
                                        .VoteOptionId;
                                AddIfMissingPrecinctResult(voteoptionid, precinctId, count, ref resultsList, ref resultsListToAdd);
                            }
                        }
                    }
                    var splitResultList = resultsListToAdd.Select((x, i) => new { Index = i, Value = x })
            .GroupBy(x => x.Index / 10000)
            .Select(x => x.Select(v => v.Value).ToList())
            .ToList();

                    foreach (var splitresult in splitResultList)
                    {
                        try
                        {
                            a.Results.AddRange(splitresult);
                            await a.SaveChangesAsync();
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception in Data update: {ex.ToString()}");
            }
        }
        private static async Task ScrapePrecinctDataFromMasterPreceinctCSV()
        {
            var a = new ElectionData.Models.ElectionData();
            a.Configuration.AutoDetectChangesEnabled = false;
            a.Configuration.ValidateOnSaveEnabled = false;

            try
            {

                //using (var stream = new MemoryStream())
                //{
                //    var precinctResults = await Get(new UriBuilder(
                //            $"http://results.vote.wa.gov/results/current/export/{ElectionCycle}_AllStatePrecincts.csv").Uri,
                //        300);

                //    IList<VoteOption> voteOptionList = await a.VoteOptions.ToListAsync();

                //    var bytes = System.Text.Encoding.Default.GetBytes(precinctResults);
                //    stream.Write(bytes, 0, bytes.Length);
                //    IList<County> countyList = await a.Counties.ToListAsync();
                //    IList<Precinct> precinctList = await a.Precincts.ToListAsync();
                //    IList<Result> results = new List<Result>();

                //    stream.Seek(0, SeekOrigin.Begin);
                //    var index = 0;
                //    using (TextFieldParser parser = new TextFieldParser(stream))
                //    {
                //        parser.TextFieldType = FieldType.Delimited;
                //        parser.SetDelimiters(",");
                //        parser.ReadFields(); //skip header
                //        while (!parser.EndOfData)
                //        {

                //            //Processing row
                //            string[] fields = parser.ReadFields();
                //            var race = fields[0];
                //            var countycode = fields[1];
                //            var candidate = fields[2];
                //            var precinctname = fields[3];
                //            var precinctcode = Int32.Parse(fields[4]);
                //            var count = Int32.Parse(fields[5]);
                //            if (precinctname != "Total")
                //            {
                //                Console.WriteLine($"Record: {index++}");
                //                AddIfMissingVoteOptionId(race, candidate, "", "", ref voteOptionList);
                //            }

                //        }
                //    }
                //    a.VoteOptions.AddOrUpdate(c => c.VoteOptionId, voteOptionList.ToArray());
                //    await a.SaveChangesAsync();
                //}
                //using (var stream = new MemoryStream())
                //{
                //    var precinctResults = await Get(new UriBuilder(
                //        $"http://results.vote.wa.gov/results/current/export/{ElectionCycle}_AllStatePrecincts.csv").Uri, 300);

                //    IList<VoteOption> voteOptionList = await a.VoteOptions.ToListAsync();

                //    var bytes = System.Text.Encoding.Default.GetBytes(precinctResults);
                //    stream.Write(bytes, 0, bytes.Length);
                //    /// Now for Precinct
                //    var countyList = await a.Counties.ToListAsync();
                //    IList<Precinct> precinctList = await a.Precincts.ToListAsync();

                //    stream.Seek(0, SeekOrigin.Begin);
                //    var index = 0;
                //    using (TextFieldParser parser = new TextFieldParser(stream))
                //    {
                //        parser.TextFieldType = FieldType.Delimited;
                //        parser.SetDelimiters(",");
                //        parser.ReadFields();//skip header
                //        while (!parser.EndOfData)
                //        {

                //            //Processing row
                //            string[] fields = parser.ReadFields();
                //            var race = fields[0];
                //            var countycode = fields[1];
                //            var candidate = fields[2];
                //            var precinctname = fields[3];
                //            var precinctcode = Int32.Parse(fields[4]);
                //            var count = Int32.Parse(fields[5]);
                //            if (precinctname != "Total")
                //            {
                //                Console.WriteLine($"Record: {index++}");
                //                var countyid =
                //                    countyList
                //                        .FirstOrDefault(b => b.CountyCode == countycode && b.State == "WA")
                //                        .CountyId;
                //                AddIfMissingPrecinct(countyid, precinctcode, precinctname, ref precinctList);
                //            }

                //        }
                //    }
                //    a.Precincts.AddOrUpdate(c => c.PrecinctId, precinctList.ToArray());
                //    await a.SaveChangesAsync();

                //}
                //Now for results
                using (var stream = new MemoryStream())
                {
                    var precinctResults = await Get(new UriBuilder(
                        $"http://results.vote.wa.gov/results/current/export/{ElectionCycle}_AllStatePrecincts.csv").Uri, 300);

                    IList<VoteOption> voteOptionList = await a.VoteOptions.ToListAsync();

                    var bytes = System.Text.Encoding.Default.GetBytes(precinctResults);
                    stream.Write(bytes, 0, bytes.Length);
                    var countyList = await a.Counties.ToListAsync();
                    var precinctList = await a.Precincts.ToListAsync();
                    IList<Result> resultsList = await a.Results.ToListAsync();
                    IList<Result> resultsListToAdd = new List<Result>();

                    stream.Seek(0, SeekOrigin.Begin);
                    var index = 0;
                    using (TextFieldParser parser = new TextFieldParser(stream))
                    {
                        parser.TextFieldType = FieldType.Delimited;
                        parser.SetDelimiters(",");
                        parser.ReadFields();//skip header
                        while (!parser.EndOfData)
                        {

                            //Processing row
                            string[] fields = parser.ReadFields();
                            var race = fields[0];
                            var countycode = fields[1];
                            var candidate = fields[2];
                            var precinctname = fields[3];
                            var precinctcode = Int32.Parse(fields[4]);
                            var count = Int32.Parse(fields[5]);
                            if (precinctname != "Total")
                            {
                                Console.WriteLine($"Record: {index++}");
                                var countyid =
                                    countyList
                                        .FirstOrDefault(b => b.CountyCode == countycode && b.State == "WA")
                                        .CountyId;
                                var precinctId =
                                    precinctList
                                    .FirstOrDefault(b => b.CountyId == countyid && b.PrecinctCode == precinctcode)
                                    .PrecinctId;
                                var voteoptionid=
                                        voteOptionList
                                        .FirstOrDefault(b => b.Candidate == candidate && b.Race== race &&  b.ElectionCycle==ElectionCycle)
                                        .VoteOptionId;
                                AddIfMissingPrecinctResult(voteoptionid, precinctId, count, ref resultsList, ref resultsListToAdd);
                            }
                        }
                    }
                    var splitResultList= resultsListToAdd.Select((x, i) => new { Index = i, Value = x })
            .GroupBy(x => x.Index / 10000)
            .Select(x => x.Select(v => v.Value).ToList())
            .ToList();

                    foreach (var splitresult in splitResultList)
                    {
                        try
                        {
                            a.Results.AddRange(splitresult);
                            await a.SaveChangesAsync();
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception in Data update: {ex.ToString()}");
            }
        }

        private static void  AddIfMissingPrecinctResult(int voteOptionId, int precinctId, int parsedCount, ref IList<Result> results, ref IList<Result> resultsToAdd)
        {
            if (!results
                .Any(a => a.VoteOptionId== voteOptionId && a.PrecinctId== precinctId))
            {
                resultsToAdd.Add(new Result()
                {
                    PrecinctId = precinctId,
                    VoteOptionId = voteOptionId,
                    Count = parsedCount,
                    Created = DateTime.Now,
                    ResultType = "FINAL",
                    ResultsUntil = new DateTime(2016, 11, 29)
                });
            }
            //await electionData.SaveChangesAsync();
        }

        private static void AddIfMissingPrecinct(int countyId, int precinctCode, string precinctName, ref IList<Precinct> precinctList)
        {

            if (!precinctList
                        .Any(a => a.CountyId == countyId && a.PrecinctCode == precinctCode))
            {
                precinctList.Add(new Precinct()
                {
                    CountyId = countyId,
                    PrecinctCode = precinctCode,
                    PrecinctName = precinctName,
                    Created = DateTime.Now
                });
            }
        }
        private static void AddIfMissingVoteOptionId(string race, string candidate, string jurisdiction, string party, ref IList<VoteOption> voteOption)
        {

            if (!voteOption.Any(a => a.Race == race
                                  && a.Candidate == candidate
                                  && a.Jurisdiction == jurisdiction
                                  && a.Party == party
                                  && a.ElectionCycle == ElectionCycle))
            {
                voteOption.Add(new VoteOption()
                {
                    ElectionCycle = ElectionCycle,
                    Race = race,
                    Candidate = candidate,
                    Party = party,
                    Jurisdiction = jurisdiction
                });
            }

        }
        //http://stackoverflow.com/questions/12827599/parallel-doesnt-work-with-entity-framework
        public static ConcurrentQueue<Exception> Parallel<T>(this IEnumerable<T> items, Action<T> action, int? parallelCount = null, bool debugMode = true)
        {
            var exceptions = new ConcurrentQueue<Exception>();
            if (debugMode)
            {
                foreach (var item in items)
                {
                    try
                    {
                        action(item);
                    }
                    // Store the exception and continue with the loop.                     
                    catch (Exception e)
                    {
                        exceptions.Enqueue(e);
                    }
                }
            }
            else
            {
                var partitions = Partitioner.Create(items).GetPartitions(parallelCount ?? Environment.ProcessorCount).Select(partition => Task.Factory.StartNew(() =>
                {
                    while (partition.MoveNext())
                    {
                        try
                        {
                            action(partition.Current);
                        }
                        // Store the exception and continue with the loop.                     
                        catch (Exception e)
                        {
                            exceptions.Enqueue(e);
                        }
                    }
                }));
                Task.WaitAll(partitions.ToArray());
            }
            return exceptions;
        }


        private static async Task ScrapeCountyData()
        {
            HtmlDocument doc = new HtmlDocument();
            var countylist = await Get(new UriBuilder("http://results.vote.wa.gov/results/current/Turnout.html").Uri, 300);
            doc.LoadHtml(countylist);
            var a = new global::ElectionData.Models.ElectionData();

            foreach (HtmlNode link in doc.DocumentNode.SelectNodes("//tr"))
            {
                try
                {
                    HtmlAttribute att = link.Attributes["class"];
                    if (null == att)
                    {
                        var county = new County()
                        {
                            CountyName = link.ChildNodes[0].InnerText,
                            RegisteredVoters = Int32.Parse(link.ChildNodes[1].InnerText.Replace(",", "")),
                            State = "WA",
                            Created = DateTime.Parse(link.ChildNodes[4].InnerHtml.Replace("<br>", " ")),
                            BallotsCounted = Int32.Parse(link.ChildNodes[2].InnerText.Replace(",", "")),
                            Turnout = Decimal.Parse(link.ChildNodes[3].InnerText.Replace("%", "")),

                        };
                        a.Counties.Add(county);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                }
            }
            await a.SaveChangesAsync();
            //doc.Save("file.htm");
        }

        public static async Task<string> Get(Uri url, int timeOutinSeconds = 60)
        {
            using (var handler = new HttpClientHandler())
            {
                using (var httpClient = new HttpClient(handler))
                {
                    httpClient.Timeout = new TimeSpan(0, 0, 0, timeOutinSeconds);
                    var response = await httpClient.GetAsync(url);
                    {
                        var content = await response.Content.ReadAsStringAsync();
                        if (!response.IsSuccessStatusCode)
                        {
                            Trace.WriteLine("Status:  " + response.StatusCode);
                            Trace.WriteLine("Content: " + content);
                        }
                        response.EnsureSuccessStatusCode();
                        return content;
                    }
                }
            }
        }

        public static async Task<Stream> GetStream(Uri url, int timeOutinSeconds = 60)
        {
            using (var handler = new HttpClientHandler())
            {
                using (var httpClient = new HttpClient(handler))
                {
                    httpClient.Timeout = new TimeSpan(0, 0, 0, timeOutinSeconds);
                    return await httpClient.GetStreamAsync(url);
                }
            }
        }
        private static void GetCounties()
        {
            var c = new County()
            {
                CountyName = "Faiz",
                State = "WA"
            };

            var a = new global::ElectionData.Models.ElectionData();
            a.Counties.RemoveRange(a.Counties.ToList());
            a.SaveChanges();
        }


        /*
        private static async Task ScrapePrecinctDataSIngleThread(int low, int high)
        {
            var a = new global::ElectionData.Models.ElectionData();
            IList<County> countList = await a.Counties.Where(b=> b.CountyId>=low && b.CountyId<=high).ToListAsync();
            IList<Result> results = new List<Result>();
            foreach (var county in countList)
            {
                try
                {
                    if (county.CountyId >= 6)
                    {
                        Console.WriteLine($"{county.CountyId} :{county.CountyName}");

                        results = new List<Result>();

                        using (var stream = new MemoryStream())
                        {
                            var precinctResults =
                                await
                                    Get(
                                        new UriBuilder(
                                                $"http://results.vote.wa.gov/results/current/export/{ElectionCycle}_{county.CountyName}Precincts.csv")
                                            .Uri, 300);

                            var bytes = System.Text.Encoding.Default.GetBytes(precinctResults);
                            stream.Write(bytes, 0, bytes.Length);
                            stream.Seek(0, SeekOrigin.Begin);
                            var index = 0;
                            using (TextFieldParser parser = new TextFieldParser(stream))
                            {
                                parser.TextFieldType = FieldType.Delimited;
                                parser.SetDelimiters(",");
                                while (!parser.EndOfData)
                                {

                                    //Processing row
                                    string[] fields = parser.ReadFields();
                                    var vote = fields[0];
                                    var voteoption = fields[1];
                                    var precinctname = fields[2];
                                    var count = Int32.Parse(fields[4]);
                                    if (fields[2] != "Total")
                                    {
                                        Console.WriteLine($"Record: {index++}");
                                        //await AddIfMissingVoteOptionId(vote, voteoption, a);
                                        var voteOptionId =
                                            a.VoteOptions.Single(
                                                opt => opt.Vote == vote && opt.VoteOptionName == voteoption
                                                       && opt.ElectionCycle == ElectionCycle).VoteOptionId;

                                        await AddIfMissingPrecinct(county.CountyId, precinctname, a);
                                        var precinctId =
                                            a.Precincts.Single(
                                                opt =>
                                                    opt.CountyId == county.CountyId &&
                                                    opt.PrecinctName == precinctname
                                            ).PrecinctId;

                                        await AddPrecinctResult(voteOptionId, precinctId, count, results);
                                    }

                                }
                            }
                        }
                        a.Results.AddRange(results);
                        await a.SaveChangesAsync();
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Exception in County {county.CountyId}:{county.CountyName} Data update: {ex.ToString()}");
                }
            }

    }
    */
        /*
    private static async Task ScrapePrecinctData(int low , int high)
    {
        var a = new global::ElectionData.Models.ElectionData();
        IList<County> countyList = await a.Counties.Where(b => b.CountyId >= low && b.CountyId <= high).ToListAsync();


        var exceptions = countyList.Parallel(async (county) =>
        {
            using (var batchDb = new global::ElectionData.Models.ElectionData())
            {
                try
                {
                    IList<Result> results = new List<Result>();
                    using (var stream = new MemoryStream())
                    {
                        var precinctResults =
                            await
                                Get(
                                    new UriBuilder(
                                            $"http://results.vote.wa.gov/results/current/export/{ElectionCycle}_{county.CountyName}Precincts.csv")
                                        .Uri, 300);

                        var bytes = System.Text.Encoding.Default.GetBytes(precinctResults);
                        stream.Write(bytes, 0, bytes.Length);
                        stream.Seek(0, SeekOrigin.Begin);
                        var index = 0;
                        using (TextFieldParser parser = new TextFieldParser(stream))
                        {
                            parser.TextFieldType = FieldType.Delimited;
                            parser.SetDelimiters(",");
                            while (!parser.EndOfData)
                            {

                                //Processing row
                                string[] fields = parser.ReadFields();
                                var vote = fields[0];
                                var voteoption = fields[1];
                                var precinctname = fields[2];
                                var count = Int32.Parse(fields[4]);
                                if (fields[2] != "Total")
                                {
                                    Console.WriteLine($"Record: {index++}");
                                    //await AddIfMissingVoteOptionId(vote, voteoption, a);
                                    var voteOptionId =
                                        a.VoteOptions.Single(
                                            opt => opt.Vote == vote && opt.VoteOptionName == voteoption
                                                   && opt.ElectionCycle == ElectionCycle).VoteOptionId;

                                    await AddIfMissingPrecinct(county.CountyId, precinctname, a);
                                    var precinctId =
                                        a.Precincts.Single(
                                            opt =>
                                                opt.CountyId == county.CountyId &&
                                                opt.PrecinctName == precinctname
                                        ).PrecinctId;

                                    await AddPrecinctResult(voteOptionId, precinctId, count, results);
                                }

                            }
                        }
                        batchDb.Results.AddRange(results);
                        await batchDb.SaveChangesAsync();
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(
                        $"Exception in County {county.CountyId}:{county.CountyName} Data update: {ex.ToString()}");
                }
            }

        }, 10, false);
        if (exceptions.Count > 0)
        {
            Console.WriteLine("ContactRecordMigration : Content: Error processing one or more records",
                new AggregateException(exceptions));
            throw new AggregateException(exceptions); //optionally throw an exception
        }
        await a.SaveChangesAsync();
    }
    */

    }
}

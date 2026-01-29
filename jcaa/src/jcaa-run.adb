with JCAA.Tests;
with Trendy_Test.Reports;

procedure JCAA.Run is
begin
   Trendy_Test.Register (JCAA.Tests.All_Tests);
   Trendy_Test.Reports.Print_Basic_Report (Trendy_Test.Run);
end JCAA.Run;

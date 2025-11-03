--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test.Reports;
with Testsuite.Vectors;
procedure Testsuite.Driver is
   All_Tests : constant Trendy_Test.Test_Group :=
     Testsuite.Vectors.All_Tests;
begin
   Trendy_Test.Register (All_Tests);
   Trendy_Test.Reports.Print_Basic_Report (Trendy_Test.Run);
end Testsuite.Driver;

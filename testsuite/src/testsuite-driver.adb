--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test.Reports;
with Testsuite.Vectors;
with Testsuite.Matrices;
with Testsuite.Eigen_Systems;
procedure Testsuite.Driver is
   use type Trendy_Test.Test_Group;

   All_Tests : constant Trendy_Test.Test_Group :=
     Testsuite.Vectors.All_Tests & Testsuite.Matrices.All_Tests &
     Testsuite.Eigen_Systems.All_Tests;
begin
   Trendy_Test.Register (All_Tests);
   Trendy_Test.Reports.Print_Basic_Report (Trendy_Test.Run);
end Testsuite.Driver;

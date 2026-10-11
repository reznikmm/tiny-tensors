--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

with Ada.Command_Line;
with Ada.Text_IO;
with Slim_Test.Results;
with Slim_Test.Test_Groups;
with Testsuite.Vectors;
with Testsuite.Matrices;
with Testsuite.Diagonal_Matrices;
with Testsuite.Symmetric_Matrices;
with Testsuite.Orthonormal_Matrices;
with Testsuite.Skew_Symmetric_Matrices;
with Testsuite.Eigen_Systems;
with Testsuite.SVD;
procedure Testsuite.Driver is
   Total   : Natural := 0;
   Failed  : Natural := 0;
   Skipped : Natural := 0;

   procedure Run
     (Name      : String;
      All_Tests : Slim_Test.Test_Groups.Test_Group);

   procedure Run
     (Name      : String;
      All_Tests : Slim_Test.Test_Groups.Test_Group)
   is
      use Slim_Test.Test_Groups;
      Group : Test_Group := All_Tests;
   begin
      Slim_Test.Test_Groups.Run (Group);

      Total := Total + Group.Length;
      Failed := Failed + Slim_Test.Test_Groups.Failed (Group);
      Skipped := Skipped + Slim_Test.Test_Groups.Skipped (Group);

      for Index in 1 .. Group.Length loop
         declare
            Test_Result : constant Slim_Test.Results.Result :=
              Result (Group, Index);
         begin
            Ada.Text_IO.Put
              (Name & "." & Slim_Test.Test_Groups.Name (Group, Index));

            if Slim_Test.Results.Is_Failed (Test_Result) then
               Ada.Text_IO.Put_Line (": FAILED");
            elsif Slim_Test.Results.Is_Skipped (Test_Result) then
               Ada.Text_IO.Put_Line (": SKIPPED");
            else
               Ada.Text_IO.Put_Line (": PASSED");
            end if;
         end;
      end loop;
   end Run;
begin
   Run ("Vectors", Testsuite.Vectors.All_Tests);
   Run ("Matrices", Testsuite.Matrices.All_Tests);
   Run ("Diagonal_Matrices", Testsuite.Diagonal_Matrices.All_Tests);
   Run ("Symmetric_Matrices", Testsuite.Symmetric_Matrices.All_Tests);
   Run ("Orthonormal_Matrices", Testsuite.Orthonormal_Matrices.All_Tests);
   Run
     ("Skew_Symmetric_Matrices", Testsuite.Skew_Symmetric_Matrices.All_Tests);
   Run ("Eigen_Systems", Testsuite.Eigen_Systems.All_Tests);
   Run ("SVD", Testsuite.SVD.All_Tests);

   Ada.Text_IO.Put_Line
     ("Tests:" & Total'Image & ", failed:" & Failed'Image &
      ", skipped:" & Skipped'Image);

   if Failed > 0 then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Testsuite.Driver;

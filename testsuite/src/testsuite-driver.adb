--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

with Ada.Command_Line;
with Ada.Text_IO;

with Slim_Test.Group_Lists;
with Slim_Test.Results;

with Testsuite.Vectors;
with Testsuite.Matrices;
with Testsuite.Diagonal_Matrices;
with Testsuite.Symmetric_Matrices;
with Testsuite.Orthonormal_Matrices;
with Testsuite.Skew_Symmetric_Matrices;
with Testsuite.Eigen_Systems;
with Testsuite.SVD;

procedure Testsuite.Driver is
   Failed  : Natural := 0;
   Skipped : Natural := 0;

   List : constant Slim_Test.Group_Lists.Group_List :=
     ["Vectors"              => Testsuite.Vectors.All_Tests'Access,
      "Matrices"             => Testsuite.Matrices.All_Tests'Access,
      "Diagonal_Matrices"    => Testsuite.Diagonal_Matrices.All_Tests'Access,
      "Symmetric_Matrices"   => Testsuite.Symmetric_Matrices.All_Tests'Access,
      "Orthonormal_Matrices" =>
        Testsuite.Orthonormal_Matrices.All_Tests'Access,
      "Skew_Symmetric_Matrices" =>
        Testsuite.Skew_Symmetric_Matrices.All_Tests'Access,
      "Eigen_Systems"           => Testsuite.Eigen_Systems.All_Tests'Access,
      "SVD"                     => Testsuite.SVD.All_Tests'Access];

   Result : Slim_Test.Results.Result_Array
     (1 .. Slim_Test.Group_Lists.Last_Index (List));

begin
   Slim_Test.Group_Lists.Run (List, Result);

   for K in Result'Range loop
      Ada.Text_IO.Put (Slim_Test.Group_Lists.Test_Name (List, K));

      if Slim_Test.Results.Is_Failed (Result (K)) then
         Ada.Text_IO.Put_Line (": FAILED");
         Failed := Failed + 1;
      elsif Slim_Test.Results.Is_Skipped (Result (K)) then
         Ada.Text_IO.Put_Line (": SKIPPED");
         Skipped := Skipped + 1;
      else
         Ada.Text_IO.Put_Line (": PASSED");
      end if;
   end loop;

   Ada.Text_IO.Put_Line
     ("Tests:" & Result'Length'Image & ", failed:" & Failed'Image &
      ", skipped:" & Skipped'Image);

   if Failed > 0 then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Testsuite.Driver;

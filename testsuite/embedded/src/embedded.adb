--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Text_IO;
with Slim_Test.Execution_Time;

with Slim_Test.Group_Lists;
with Slim_Test.Groups;
with Slim_Test.Results;

with Testsuite.Diagonal_Matrices;
with Testsuite.Eigen_Systems;
with Testsuite.Matrices;
with Testsuite.No_Operation;
with Testsuite.Orthonormal_Matrices;
with Testsuite.Skew_Symmetric_Matrices;
with Testsuite.SVD;
with Testsuite.Symmetric_Matrices;
with Testsuite.Vectors;

procedure Embedded is
   Failed  : Natural := 0;
   Skipped : Natural := 0;

   procedure Dump
     (Group  :  Slim_Test.Groups.Test_Group;
      Result : Slim_Test.Results.Result_Array);

   procedure General_Tests;

   procedure General_Tests is
      List : constant Slim_Test.Group_Lists.Group_List :=
        ["Vectors"              => Testsuite.Vectors.All_Tests'Access,
         "Matrices"             => Testsuite.Matrices.All_Tests'Access,
         "Diagonal_Matrices"    =>
           Testsuite.Diagonal_Matrices.All_Tests'Access,
         "Symmetric_Matrices"   =>
           Testsuite.Symmetric_Matrices.All_Tests'Access,
         "Orthonormal_Matrices" =>
           Testsuite.Orthonormal_Matrices.All_Tests'Access,
         "Skew_Symmetric_Matrices" =>
           Testsuite.Skew_Symmetric_Matrices.All_Tests'Access,
         "Eigen_Systems"        => Testsuite.Eigen_Systems.All_Tests'Access,
         "SVD"                  => Testsuite.SVD.All_Tests'Access];

      Result : Slim_Test.Results.Result_Array
        (1 .. Slim_Test.Group_Lists.Last_Index (List));
   begin
      Slim_Test.Group_Lists.Run (List, Result);

      for K in Result'Range loop
         if Slim_Test.Results.Is_Failed (Result (K)) then
            Ada.Text_IO.Put (Slim_Test.Group_Lists.Test_Name (List, K));
            Ada.Text_IO.Put_Line (": FAILED");
            Failed := Failed + 1;
         elsif Slim_Test.Results.Is_Skipped (Result (K)) then
            Skipped := Skipped + 1;
         end if;
      end loop;

      Ada.Text_IO.Put_Line
        ("Tests:" & Result'Length'Image & ", failed:" & Failed'Image &
           ", skipped:" & Skipped'Image);

      Ada.Text_IO.New_Line;
      Ada.Text_IO.New_Line;
   end General_Tests;

   procedure Dump
     (Group  :  Slim_Test.Groups.Test_Group;
      Result : Slim_Test.Results.Result_Array)
   is
      use type Slim_Test.Execution_Time.Time_Span;
      Time : Slim_Test.Execution_Time.Time_Span;
   begin
      for K in 2 .. Result'Last loop
         Ada.Text_IO.Put (Slim_Test.Groups.Name (Group, K));

         Time := Slim_Test.Results.Execution_Time (Result (K))
           - Slim_Test.Results.Execution_Time (Result (1));

         Ada.Text_IO.Put_Line (Time'Image);

         if Slim_Test.Results.Is_Failed (Result (K)) then
            Ada.Text_IO.Put_Line (": FAILED!");
            Failed := Failed + 1;
         elsif Slim_Test.Results.Is_Skipped (Result (K)) then
            Ada.Text_IO.Put_Line (": SKIPPED!");
            Skipped := Skipped + 1;
         end if;
      end loop;

      Ada.Text_IO.Put ("Test overhead (excluded):");
      Ada.Text_IO.Put_Line
        (Slim_Test.Results.Execution_Time (Result (1))'Image);

      Ada.Text_IO.Put_Line
        ("Tests:" & Result'Length'Image & ", failed:" & Failed'Image &
           ", skipped:" & Skipped'Image);

      Ada.Text_IO.New_Line;
      Ada.Text_IO.New_Line;
   end Dump;

   Group : constant Slim_Test.Groups.Test_Group :=
     ["No_Operation"   => Testsuite.No_Operation.Test'Access,
      "Eigen_System_1" => Testsuite.Eigen_Systems.Eigen_System_1'Access,
      "Eigen_System_2" => Testsuite.Eigen_Systems.Eigen_System_2'Access,
      "Matrices.Adj_1" => Testsuite.Matrices.Test_Adj_1'Access,
      "Matrices.Adj_2" => Testsuite.Matrices.Test_Adj_2'Access,
      "Matrices.M_x_V" => Testsuite.Matrices.Test_Matrix_x_Vector_1'Access,
      "Matrices.Det"   => Testsuite.Matrices.Test_Det_1'Access,
      "Matrices.A_x_B" => Testsuite.Matrices.Test_A_x_B_1'Access,
      "Matrices.Inv_1" => Testsuite.Matrices.Test_Inverse_1'Access,
      "Matrices.Inv_2" => Testsuite.Matrices.Test_Inverse_2'Access,
      "SVD"            => Testsuite.SVD.Simple_Matrix_SVD_1'Access,
      "Symmetric.Adj"  => Testsuite.Symmetric_Matrices.Test_Adj_1'Access,
      "Symmetric.Det"  => Testsuite.Symmetric_Matrices.Test_Det_1'Access,
      "Symmetric.Q_A_QT" => Testsuite.Symmetric_Matrices.Test_Q_A_QT_1'Access];

   Result : array (1 .. 4) of
     Slim_Test.Results.Result_Array (1 .. Group.Length);

begin
   for Item of Result loop
      Slim_Test.Groups.Run (Group, Item);
   end loop;

   for Item of Result loop
      Dump (Group, Item);
   end loop;

   General_Tests;

   loop
      delay 2.0;
   end loop;
end Embedded;

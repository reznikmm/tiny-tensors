--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Groups;

package Testsuite.Matrices is

   All_Tests : aliased constant Slim_Test.Groups.Test_Group;

   --  Time tests
   procedure Test_Adj_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Adj_2 (T : in out Slim_Test.Results.Result);
   procedure Test_Matrix_x_Vector_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Det_1 (T : in out Slim_Test.Results.Result);
   procedure Test_A_x_B_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Inverse_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Inverse_2 (T : in out Slim_Test.Results.Result);

private

   procedure Basic_Matrix_Operations (T : in out Slim_Test.Results.Result);
   procedure Test_Adj (T : in out Slim_Test.Results.Result);

   procedure Test_Matrix_x_Vector (T : in out Slim_Test.Results.Result);
   procedure Test_Identity_x_Vector (T : in out Slim_Test.Results.Result);

   procedure Test_Determinant (T : in out Slim_Test.Results.Result);

   procedure Test_LT_x_R (T : in out Slim_Test.Results.Result);

   procedure Test_Inverse (T : in out Slim_Test.Results.Result);
   procedure Test_Inverse_Identity (T : in out Slim_Test.Results.Result);

   All_Tests : aliased constant Slim_Test.Groups.Test_Group :=
    ["Basic_Matrix_Operations" => Basic_Matrix_Operations'Access,
     "Adj" => Test_Adj'Access,
     "M_x_V" => Test_Matrix_x_Vector'Access,
     "I_x_V" => Test_Identity_x_Vector'Access,
     "Determinant" => Test_Determinant'Access,
     "LT_x_R" => Test_LT_x_R'Access,
     "Inverse" => Test_Inverse'Access,
     "Inverse_Identity" => Test_Inverse_Identity'Access];

end Testsuite.Matrices;

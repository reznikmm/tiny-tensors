--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.Matrices is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

private

   procedure Basic_Matrix_Operations (T : in out Slim_Test.Results.Result);
   procedure Test_Adj_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Adj_2 (T : in out Slim_Test.Results.Result);

   procedure Test_Matrix_x_Vector_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Matrix_x_Vector_2 (T : in out Slim_Test.Results.Result);

   procedure Test_Determinant (T : in out Slim_Test.Results.Result);

   procedure Test_LT_x_R (T : in out Slim_Test.Results.Result);
   procedure Test_A_x_B (T : in out Slim_Test.Results.Result);

   procedure Test_Inverse_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Inverse_2 (T : in out Slim_Test.Results.Result);
   procedure Test_Inverse_3 (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Basic_Matrix_Operations" => Basic_Matrix_Operations'Access,
     "Adj_1" => Test_Adj_1'Access,
     "Adj_2" => Test_Adj_2'Access,
     "M_x_V_1" => Test_Matrix_x_Vector_1'Access,
     "M_x_V_2" => Test_Matrix_x_Vector_2'Access,
     "Determinant" => Test_Determinant'Access,
     "A_x_B"  => Test_A_x_B'Access,
     "LT_x_R" => Test_LT_x_R'Access,
     "Inverse_1" => Test_Inverse_1'Access,
     "Inverse_2" => Test_Inverse_2'Access,
     "Inverse_3" => Test_Inverse_3'Access];

end Testsuite.Matrices;

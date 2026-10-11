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
   procedure Test_Adj (T : in out Slim_Test.Results.Result);

   procedure Test_Matrix_Vector_Multiplication
     (T : in out Slim_Test.Results.Result);

   procedure Test_Determinant (T : in out Slim_Test.Results.Result);

   procedure Test_LT_x_R_Operations (T : in out Slim_Test.Results.Result);

   procedure Test_Inverse (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Basic_Matrix_Operations" => Basic_Matrix_Operations'Access,
     "Test_Adj" => Test_Adj'Access,
     "Test_Matrix_Vector_Multiplication" =>
       Test_Matrix_Vector_Multiplication'Access,
     "Test_Determinant" => Test_Determinant'Access,
     "Test_LT_x_R_Operations" => Test_LT_x_R_Operations'Access,
     "Test_Inverse" => Test_Inverse'Access];

end Testsuite.Matrices;

--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.Symmetric_Matrices is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

private

   procedure Test_Symmetric_Matrix_Operations
     (T : in out Slim_Test.Results.Result);

   procedure Test_Symmetric_Adj (T : in out Slim_Test.Results.Result);

   procedure Test_Determinant (T : in out Slim_Test.Results.Result);

   procedure Test_LT_x_L_Operations (T : in out Slim_Test.Results.Result);

   procedure Test_Scalar_And_Mixed_Operations
     (T : in out Slim_Test.Results.Result);

   procedure Test_Inverse (T : in out Slim_Test.Results.Result);

   procedure Test_Q_A_QT (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Test_Symmetric_Matrix_Operations" =>
       Test_Symmetric_Matrix_Operations'Access,
     "Test_Symmetric_Adj" => Test_Symmetric_Adj'Access,
     "Test_Determinant" => Test_Determinant'Access,
     "Test_LT_x_L_Operations" => Test_LT_x_L_Operations'Access,
     "Test_Scalar_And_Mixed_Operations" =>
       Test_Scalar_And_Mixed_Operations'Access,
     "Test_Inverse" => Test_Inverse'Access,
     "Test_Q_A_QT" => Test_Q_A_QT'Access];

end Testsuite.Symmetric_Matrices;

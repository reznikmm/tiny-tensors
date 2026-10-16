--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Groups;

package Testsuite.Symmetric_Matrices is

   All_Tests : aliased constant Slim_Test.Groups.Test_Group;

   --  Time tests
   procedure Test_Adj_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Det_1 (T : in out Slim_Test.Results.Result);
   procedure Test_Q_A_QT_1 (T : in out Slim_Test.Results.Result);

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

   All_Tests : aliased constant Slim_Test.Groups.Test_Group :=
    ["Symmetric_Matrix_Operations" =>
       Test_Symmetric_Matrix_Operations'Access,
     "Symmetric_Adj" => Test_Symmetric_Adj'Access,
     "Determinant" => Test_Determinant'Access,
     "LT_x_L_Operations" => Test_LT_x_L_Operations'Access,
     "Scalar_And_Mixed_Operations" =>
       Test_Scalar_And_Mixed_Operations'Access,
     "Inverse" => Test_Inverse'Access,
     "Q_A_QT" => Test_Q_A_QT'Access];

end Testsuite.Symmetric_Matrices;

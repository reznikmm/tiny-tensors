--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test;

package Testsuite.Symmetric_Matrices is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Test_Symmetric_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Symmetric_Adj (T : in out Trendy_Test.Operation'Class);

   procedure Test_Determinant (T : in out Trendy_Test.Operation'Class);

   procedure Test_LT_x_L_Operations (T : in out Trendy_Test.Operation'Class);

   procedure Test_Scalar_And_Mixed_Operations
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Inverse (T : in out Trendy_Test.Operation'Class);

   procedure Test_Q_A_QT (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
    [Test_Symmetric_Matrix_Operations'Access,
     Test_Symmetric_Adj'Access,
     Test_Determinant'Access,
     Test_LT_x_L_Operations'Access,
     Test_Scalar_And_Mixed_Operations'Access,
     Test_Inverse'Access,
     Test_Q_A_QT'Access];

end Testsuite.Symmetric_Matrices;

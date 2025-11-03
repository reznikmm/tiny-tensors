--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test;

package Testsuite.Matrices is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Basic_Matrix_Operations (T : in out Trendy_Test.Operation'Class);

   procedure Test_Matrix_Vector_Multiplication
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Symmetric_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
    [Basic_Matrix_Operations'Access,
     Test_Matrix_Vector_Multiplication'Access,
     Test_Symmetric_Matrix_Operations'Access];

end Testsuite.Matrices;
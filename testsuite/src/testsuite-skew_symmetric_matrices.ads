--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test;

package Testsuite.Skew_Symmetric_Matrices is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Test_Construction
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Arithmetic
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Vector_Product
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Matrix_Products
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Adjugate_And_Gramian
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Mixed_Operations
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Square
     (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
    [Test_Construction'Access,
     Test_Arithmetic'Access,
     Test_Vector_Product'Access,
     Test_Matrix_Products'Access,
     Test_Adjugate_And_Gramian'Access,
     Test_Mixed_Operations'Access,
     Test_Square'Access];

end Testsuite.Skew_Symmetric_Matrices;

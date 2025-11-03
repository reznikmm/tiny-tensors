--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test;

package Testsuite.Vectors is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Basic_Vector_Operations (T : in out Trendy_Test.Operation'Class);
   procedure Test_Triple_Product (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
    [Basic_Vector_Operations'Access, Test_Triple_Product'Access];

end Testsuite.Vectors;
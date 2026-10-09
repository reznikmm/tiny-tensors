--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test;

package Testsuite.Orthonormal_Matrices is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Test_Orthonormal_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Inverse
     (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
    [Test_Orthonormal_Matrix_Operations'Access,
     Test_Inverse'Access];

end Testsuite.Orthonormal_Matrices;

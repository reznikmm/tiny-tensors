--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test;

package Testsuite.SVD is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Identity_Matrix_SVD (T : in out Trendy_Test.Operation'Class);
   procedure Diagonal_Matrix_SVD (T : in out Trendy_Test.Operation'Class);
   procedure SVD_Reconstruction (T : in out Trendy_Test.Operation'Class);
   procedure Simple_Matrix_SVD (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
    [Identity_Matrix_SVD'Access,
     Diagonal_Matrix_SVD'Access,
     SVD_Reconstruction'Access,
     Simple_Matrix_SVD'Access];

end Testsuite.SVD;
--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Trendy_Test;

package Testsuite.Eigen_Systems is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Basic_Eigen_System_Operations
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Diagonal_Matrix_Eigen_System
     (T : in out Trendy_Test.Operation'Class);

   procedure Test_Identity_Matrix_Eigen_System
     (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
    [Basic_Eigen_System_Operations'Access,
     Test_Diagonal_Matrix_Eigen_System'Access,
     Test_Identity_Matrix_Eigen_System'Access];

end Testsuite.Eigen_Systems;
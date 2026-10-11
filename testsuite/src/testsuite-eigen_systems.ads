--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.Eigen_Systems is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

private

   procedure Basic_Eigen_System_Operations
     (T : in out Slim_Test.Results.Result);

   procedure Test_Diagonal_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result);

   procedure Test_Identity_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Basic_Eigen_System_Operations" => Basic_Eigen_System_Operations'Access,
     "Test_Diagonal_Matrix_Eigen_System" =>
       Test_Diagonal_Matrix_Eigen_System'Access,
     "Test_Identity_Matrix_Eigen_System" =>
       Test_Identity_Matrix_Eigen_System'Access];

end Testsuite.Eigen_Systems;

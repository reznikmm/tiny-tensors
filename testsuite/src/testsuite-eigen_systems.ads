--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Groups;

package Testsuite.Eigen_Systems is

   All_Tests : aliased constant Slim_Test.Groups.Test_Group;

   --  Time tests
   procedure Eigen_System_1 (T : in out Slim_Test.Results.Result);
   procedure Eigen_System_2 (T : in out Slim_Test.Results.Result);

private

   procedure Basic_Eigen_System (T : in out Slim_Test.Results.Result);

   procedure Diagonal_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result);

   procedure Identity_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result);

   All_Tests : aliased constant Slim_Test.Groups.Test_Group :=
    ["Basic_Eigen_System" => Basic_Eigen_System'Access,
     "Diagonal_Matrix_Eigen_System" => Diagonal_Matrix_Eigen_System'Access,
     "Identity_Matrix_Eigen_System" => Identity_Matrix_Eigen_System'Access];

end Testsuite.Eigen_Systems;

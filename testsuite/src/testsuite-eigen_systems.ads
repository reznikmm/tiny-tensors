--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.Eigen_Systems is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

private

   procedure Basic_Eigen_System (T : in out Slim_Test.Results.Result);
   procedure Sample_Eigen_System_1 (T : in out Slim_Test.Results.Result);
   procedure Sample_Eigen_System_2 (T : in out Slim_Test.Results.Result);

   procedure Diagonal_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result);

   procedure Identity_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Basic_Eigen_System" => Basic_Eigen_System'Access,
     "Sample_Eigen_System_1" => Sample_Eigen_System_1'Access,
     "Sample_Eigen_System_2" => Sample_Eigen_System_2'Access,
     "Diagonal_Matrix_Eigen_System" => Diagonal_Matrix_Eigen_System'Access,
     "Identity_Matrix_Eigen_System" => Identity_Matrix_Eigen_System'Access];

end Testsuite.Eigen_Systems;

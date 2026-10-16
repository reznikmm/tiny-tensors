--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Groups;

package Testsuite.Orthonormal_Matrices is

   All_Tests : aliased constant Slim_Test.Groups.Test_Group;

private

   procedure Test_Orthonormal_Matrix_Operations
     (T : in out Slim_Test.Results.Result);

   procedure Test_Inverse
     (T : in out Slim_Test.Results.Result);

   All_Tests : aliased constant Slim_Test.Groups.Test_Group :=
    ["Orthonormal_Matrix_Operations" =>
       Test_Orthonormal_Matrix_Operations'Access,
     "Inverse" => Test_Inverse'Access];

end Testsuite.Orthonormal_Matrices;

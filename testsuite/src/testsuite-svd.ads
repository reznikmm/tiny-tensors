--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.SVD is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

private

   procedure Identity_Matrix_SVD (T : in out Slim_Test.Results.Result);
   procedure Diagonal_Matrix_SVD (T : in out Slim_Test.Results.Result);
   procedure SVD_Reconstruction (T : in out Slim_Test.Results.Result);
   procedure Simple_Matrix_SVD (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Identity_Matrix_SVD" => Identity_Matrix_SVD'Access,
     "Diagonal_Matrix_SVD" => Diagonal_Matrix_SVD'Access,
     "SVD_Reconstruction" => SVD_Reconstruction'Access,
     "Simple_Matrix_SVD" => Simple_Matrix_SVD'Access];

end Testsuite.SVD;

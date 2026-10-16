--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Singular_Value_Decomposition;

package body Testsuite.SVD is
   use Slim_Test.Results;
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Diagonal_Matrices;
   use Tiny_Tensors.Float_Orthonormal_Matrices;

   procedure SVD
    (Input : Matrix;
     U     : out Orthonormal_Matrix;
     S     : out Diagonal_Matrix;
     VT    : out Orthonormal_Matrix)
       renames Tiny_Tensors.Float_Singular_Value_Decomposition.SVD;

   function Reconstruct_Matrix
     (U  : Orthonormal_Matrix;
      S  : Diagonal_Matrix;
      VT : Orthonormal_Matrix) return Matrix is (U * S * Transpose (VT));

   -------------------------
   -- Identity_Matrix_SVD --
   -------------------------

   procedure Identity_Matrix_SVD (T : in out Slim_Test.Results.Result) is
      Identity : constant Matrix := [[1.0, 0.0, 0.0],
                                     [0.0, 1.0, 0.0],
                                     [0.0, 0.0, 1.0]];
      U : Orthonormal_Matrix;
      S : Diagonal_Matrix;
      VT : Orthonormal_Matrix;
      Reconstructed : Matrix;
   begin
      SVD (Identity, U, S, VT);

      --  For identity matrix, singular values should be all 1.0
      Assert (T, S rem  [1.0, 1.0, 1.0]);

      --  Reconstruct and verify
      Reconstructed := Reconstruct_Matrix (U, S, VT);
      Assert (T, Reconstructed rem Identity);
   end Identity_Matrix_SVD;

   -------------------------
   -- Diagonal_Matrix_SVD --
   -------------------------

   procedure Diagonal_Matrix_SVD (T : in out Slim_Test.Results.Result) is
      Diagonal : constant Matrix := [[3.0, 0.0, 0.0],
                                     [0.0, 2.0, 0.0],
                                     [0.0, 0.0, 1.0]];
      U : Orthonormal_Matrix;
      S : Diagonal_Matrix;
      VT : Orthonormal_Matrix;
      Reconstructed : Matrix;
   begin
      SVD (Diagonal, U, S, VT);

      --  Singular values should be sorted in descending order
      Assert (T, S (1) >= S (2));
      Assert (T, S (2) >= S (3));
      Assert (T, S (3) >= 0.0);

      --  Reconstruct and verify
      Reconstructed := Reconstruct_Matrix (U, S, VT);
      Assert (T, Reconstructed rem Diagonal);
   end Diagonal_Matrix_SVD;

   ------------------------
   -- SVD_Reconstruction --
   ------------------------

   procedure SVD_Reconstruction (T : in out Slim_Test.Results.Result) is
      Original : constant Matrix := [[0.9, 0.2, 0.1],
                                     [0.3, 0.8, 0.4],
                                     [0.0, 0.2, 1.0]];
      U : Orthonormal_Matrix;
      S : Diagonal_Matrix;
      VT : Orthonormal_Matrix;
      Reconstructed : Matrix;
   begin
      SVD (Original, U, S, VT);

      --  Singular values should be non-negative and sorted
      Assert (T, S (1) >= S (2));
      Assert (T, S (2) >= S (3));
      Assert (T, S (3) >= 0.0);

      --  Reconstruct original matrix: A = U * S * VT
      Reconstructed := Reconstruct_Matrix (U, S, VT);
      Assert (T, Reconstructed rem Original);

      Assert (T, U rem [[0.4467, -0.7551, 0.4799],
                        [0.6520, -0.0926, -0.7525],
                        [0.6126, 0.6491, 0.4510]]);
      Assert (T, S rem [1.3183, 0.8929, 0.5046]);

      Assert (T, VT rem [[0.4533, -0.7922, 0.4086],
                         [0.5564, -0.1067, -0.8240],
                         [0.6964, 0.6009, 0.3924]]);
   end SVD_Reconstruction;

   -------------------------
   -- Simple_Matrix_SVD_1 --
   -------------------------

   procedure Simple_Matrix_SVD_1 (T : in out Slim_Test.Results.Result) is
      pragma Unreferenced (T);

      procedure Sink_Value (Discard : System.Address)
        with Import, External_Name => "sink_value";

      Original : constant Matrix := [[0.9, 0.2, 0.1],
                                     [0.3, 0.8, 0.4],
                                     [0.0, 0.2, 1.0]];
      U : Orthonormal_Matrix;
      S : Diagonal_Matrix;
      VT : Orthonormal_Matrix;
   begin
      SVD (Original, U, S, VT);

      Sink_Value (U'Address);
      Sink_Value (S'Address);
      Sink_Value (VT'Address);
   end Simple_Matrix_SVD_1;

   --------------------------
   -- Deficient_Matrix_SVD --
   --------------------------

   procedure Deficient_Matrix_SVD (T : in out Slim_Test.Results.Result) is
      --  Test with a rank-deficient matrix
      Rank_Deficient : constant Matrix := [[1.0, 2.0, 3.0],
                                           [2.0, 4.0, 6.0],
                                           [3.0, 6.0, 9.0]];
      U : Orthonormal_Matrix;
      S : Diagonal_Matrix;
      VT : Orthonormal_Matrix;
      Ignore : Matrix;
   begin
      SVD (Rank_Deficient, U, S, VT);

      --  This matrix should have rank 1, so two singular values should be 0
      Assert (T, S (1) > Epsilon);
      --  First singular value should be significant
      Assert (T, S (2) rem 0.0);  -- Second should be ~0
      Assert (T, S (3) rem 0.0);  -- Third should be ~0

      --  Reconstruct and verify
      Ignore := Reconstruct_Matrix (U, S, VT);

      --  FIXME: Make SVD work for rank-deficient matrices
      --  Assert (T, Reconstructed rem Rank_Deficient));
   end Deficient_Matrix_SVD;

end Testsuite.SVD;

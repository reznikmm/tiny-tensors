--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Singular_Value_Decomposition;

package body Testsuite.SVD is
   use Tiny_Tensors.Float_Matrices;

   procedure SVD
    (Input : Matrix;
     U     : out Orthonormal_Matrix;
     S     : out Diagonal_Matrix;
     VT    : out Orthonormal_Matrix)
       renames Tiny_Tensors.Float_Singular_Value_Decomposition;

   Tolerance : constant := 1.0e-6;

   function Close_Enough (A, B : Float) return Boolean is
     (abs (A - B) < Tolerance);

   function Close_Enough (A, B : Matrix) return Boolean is
     (for all J in 1 .. 3 =>
        (for all K in 1 .. 3 => Close_Enough (A (J, K), B (J, K))));

   function Reconstruct_Matrix
     (U  : Orthonormal_Matrix;
      S  : Diagonal_Matrix;
      VT : Orthonormal_Matrix) return Matrix is (U * S * Transpose (VT));

   -------------------------
   -- Identity_Matrix_SVD --
   -------------------------

   procedure Identity_Matrix_SVD (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
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
         T.Assert (Close_Enough (S (1), 1.0));
         T.Assert (Close_Enough (S (2), 1.0));
         T.Assert (Close_Enough (S (3), 1.0));

         --  Reconstruct and verify
         Reconstructed := Reconstruct_Matrix (U, S, VT);
         T.Assert (Close_Enough (Reconstructed, Identity));
      end;
   end Identity_Matrix_SVD;

   -------------------------
   -- Diagonal_Matrix_SVD --
   -------------------------

   procedure Diagonal_Matrix_SVD (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
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
         T.Assert (S (1) >= S (2));
         T.Assert (S (2) >= S (3));
         T.Assert (S (3) >= 0.0);

         --  Reconstruct and verify
         Reconstructed := Reconstruct_Matrix (U, S, VT);
         T.Assert (Close_Enough (Reconstructed, Diagonal));
      end;
   end Diagonal_Matrix_SVD;

   ------------------------
   -- SVD_Reconstruction --
   ------------------------

   procedure SVD_Reconstruction (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
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
         T.Assert (S (1) >= S (2));
         T.Assert (S (2) >= S (3));
         T.Assert (S (3) >= 0.0);

         --  Reconstruct original matrix: A = U * S * VT
         Reconstructed := Reconstruct_Matrix (U, S, VT);
         T.Assert (Close_Enough (Reconstructed, Original));
      end;
   end SVD_Reconstruction;

   -----------------------
   -- Simple_Matrix_SVD --
   -----------------------

   procedure Simple_Matrix_SVD (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         Simple : constant Matrix := [[2.0, 0.0, 0.0],
                                      [0.0, 3.0, 0.0],
                                      [0.0, 0.0, 1.0]];
         U : Orthonormal_Matrix;
         S : Diagonal_Matrix;
         VT : Orthonormal_Matrix;
         Reconstructed : Matrix;
      begin
         SVD (Simple, U, S, VT);

         --  Check properties of SVD
         T.Assert (S (1) >= 0.0);
         T.Assert (S (2) >= 0.0);
         T.Assert (S (3) >= 0.0);

         --  Reconstruct and verify
         Reconstructed := Reconstruct_Matrix (U, S, VT);
         T.Assert (Close_Enough (Reconstructed, Simple));
      end;

      declare
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
         T.Assert (S (1) > 1.0e-6);
         --  First singular value should be significant
         T.Assert (abs (S (2)) < 1.0e-6);  -- Second should be ~0
         T.Assert (abs (S (3)) < 1.0e-6);  -- Third should be ~0

         --  Reconstruct and verify
         Ignore := Reconstruct_Matrix (U, S, VT);

         --  FIXME: Make SVD work for rank-deficient matrices
         --  T.Assert (Close_Enough (Reconstructed, Rank_Deficient));
      end;
   end Simple_Matrix_SVD;

end Testsuite.SVD;

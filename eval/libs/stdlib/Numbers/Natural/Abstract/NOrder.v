From Hammer Require Import Hammer.











Require Export NAdd.

Module NOrderProp (Import N : NAxiomsMiniSig').
Include NAddProp N.



Theorem lt_wf_0 : well_founded lt.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_wf_0".  
setoid_replace lt with (fun n m => 0 <= n < m).
apply lt_wf.
intros x y; split.
intro H; split; [apply le_0_l | assumption]. now intros [_ H].
Defined.



Theorem nlt_0_r : forall n, ~ n < 0.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.nlt_0_r".  
intro n; apply le_ngt. apply le_0_l.
Qed.

Theorem nle_succ_0 : forall n, ~ (S n <= 0).
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.nle_succ_0".  
intros n H; apply le_succ_l in H; false_hyp H nlt_0_r.
Qed.

Theorem le_0_r : forall n, n <= 0 <-> n == 0.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_0_r".  
intros n; split; intro H.
le_elim H; [false_hyp H nlt_0_r | assumption].
now apply eq_le_incl.
Qed.

Theorem lt_0_succ : forall n, 0 < S n.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_0_succ".  
induct n; [apply lt_succ_diag_r | intros n H; now apply lt_lt_succ_r].
Qed.

Theorem neq_0_lt_0 : forall n, n ~= 0 <-> 0 < n.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.neq_0_lt_0".  
cases n.
split; intro H; [now elim H | intro; now apply lt_irrefl with 0].
intro n; split; intro H; [apply lt_0_succ | apply neq_succ_0].
Qed.

Theorem eq_0_gt_0_cases : forall n, n == 0 \/ 0 < n.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.eq_0_gt_0_cases".  
cases n.
now left.
intro; right; apply lt_0_succ.
Qed.

Theorem zero_one : forall n, n == 0 \/ n == 1 \/ 1 < n.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.zero_one".  
setoid_rewrite one_succ.
induct n. now left.
cases n. intros; right; now left.
intros n IH. destruct IH as [H | [H | H]].
false_hyp H neq_succ_0.
right; right. rewrite H. apply lt_succ_diag_r.
right; right. now apply lt_lt_succ_r.
Qed.

Theorem lt_1_r : forall n, n < 1 <-> n == 0.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_1_r".  
setoid_rewrite one_succ.
cases n.
split; intro; [reflexivity | apply lt_succ_diag_r].
intros n. rewrite <- succ_lt_mono.
split; intro H; [false_hyp H nlt_0_r | false_hyp H neq_succ_0].
Qed.

Theorem le_1_r : forall n, n <= 1 <-> n == 0 \/ n == 1.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_1_r".  
setoid_rewrite one_succ.
cases n.
split; intro; [now left | apply le_succ_diag_r].
intro n. rewrite <- succ_le_mono, le_0_r, succ_inj_wd.
split; [intro; now right | intros [H | H]; [false_hyp H neq_succ_0 | assumption]].
Qed.

Theorem lt_lt_0 : forall n m, n < m -> 0 < m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_lt_0".  
intros n m; induct n.
trivial.
intros n IH H. apply IH; now apply lt_succ_l.
Qed.

Theorem lt_1_l' : forall n m p, n < m -> m < p -> 1 < p.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_1_l'".  
intros. apply lt_1_l with m; auto.
apply le_lt_trans with n; auto. now apply le_0_l.
Qed.



Section RelElim.

Variable R : relation N.t.
Hypothesis R_wd : Proper (N.eq==>N.eq==>iff) R.

Theorem le_ind_rel :
(forall m, R 0 m) ->
(forall n m, n <= m -> R n m -> R (S n) (S m)) ->
forall n m, n <= m -> R n m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_ind_rel".  
intros Base Step; induct n.
intros; apply Base.
intros n IH m H. elim H using le_ind.
solve_proper.
apply Step; [| apply IH]; now apply eq_le_incl.
intros k H1 H2. apply le_succ_l in H1. apply lt_le_incl in H1. auto.
Qed.

Theorem lt_ind_rel :
(forall m, R 0 (S m)) ->
(forall n m, n < m -> R n m -> R (S n) (S m)) ->
forall n m, n < m -> R n m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_ind_rel".  
intros Base Step; induct n.
intros m H. apply lt_exists_pred in H; destruct H as [m' [H _]].
rewrite H; apply Base.
intros n IH m H. elim H using lt_ind.
solve_proper.
apply Step; [| apply IH]; now apply lt_succ_diag_r.
intros k H1 H2. apply lt_succ_l in H1. auto.
Qed.

End RelElim.



Theorem succ_pred_pos : forall n, 0 < n -> S (P n) == n.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.succ_pred_pos".  
intros n H; apply succ_pred; intro H1; rewrite H1 in H.
false_hyp H lt_irrefl.
Qed.

Theorem le_pred_l : forall n, P n <= n.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_pred_l".  
cases n.
rewrite pred_0; now apply eq_le_incl.
intros; rewrite pred_succ;  apply le_succ_diag_r.
Qed.

Theorem lt_pred_l : forall n, n ~= 0 -> P n < n.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_pred_l".  
cases n.
intro H; exfalso; now apply H.
intros; rewrite pred_succ;  apply lt_succ_diag_r.
Qed.

Theorem le_le_pred : forall n m, n <= m -> P n <= m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_le_pred".  
intros n m H; apply le_trans with n. apply le_pred_l. assumption.
Qed.

Theorem lt_lt_pred : forall n m, n < m -> P n < m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_lt_pred".  
intros n m H; apply le_lt_trans with n. apply le_pred_l. assumption.
Qed.

Theorem lt_le_pred : forall n m, n < m -> n <= P m.

Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_le_pred".  
intro n; cases m.
intro H; false_hyp H nlt_0_r.
intros m IH. rewrite pred_succ; now apply lt_succ_r.
Qed.

Theorem lt_pred_le : forall n m, P n < m -> n <= m.

Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_pred_le".  
intros n m; cases n.
rewrite pred_0; intro H; now apply lt_le_incl.
intros n IH. rewrite pred_succ in IH. now apply le_succ_l.
Qed.

Theorem lt_pred_lt : forall n m, n < P m -> n < m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_pred_lt".  
intros n m H; apply lt_le_trans with (P m); [assumption | apply le_pred_l].
Qed.

Theorem le_pred_le : forall n m, n <= P m -> n <= m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_pred_le".  
intros n m H; apply le_trans with (P m); [assumption | apply le_pred_l].
Qed.

Theorem pred_le_mono : forall n m, n <= m -> P n <= P m.

Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.pred_le_mono".  
intros n m H; elim H using le_ind_rel.
solve_proper.
intro; rewrite pred_0; apply le_0_l.
intros p q H1 _; now do 2 rewrite pred_succ.
Qed.

Theorem pred_lt_mono : forall n m, n ~= 0 -> (n < m <-> P n < P m).
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.pred_lt_mono".  
intros n m H1; split; intro H2.
assert (m ~= 0). apply neq_0_lt_0. now apply lt_lt_0 with n.
now rewrite <- (succ_pred n) in H2; rewrite <- (succ_pred m) in H2 ;
[apply succ_lt_mono | | |].
assert (m ~= 0). apply neq_0_lt_0. apply lt_lt_0 with (P n).
apply lt_le_trans with (P m). assumption. apply le_pred_l.
apply succ_lt_mono in H2. now do 2 rewrite succ_pred in H2.
Qed.

Theorem lt_succ_lt_pred : forall n m, S n < m <-> n < P m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_succ_lt_pred".  
intros n m. rewrite pred_lt_mono by apply neq_succ_0. now rewrite pred_succ.
Qed.

Theorem le_succ_le_pred : forall n m, S n <= m -> n <= P m.

Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_succ_le_pred".  
intros n m H. apply lt_le_pred. now apply le_succ_l.
Qed.

Theorem lt_pred_lt_succ : forall n m, P n < m -> n < S m.

Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.lt_pred_lt_succ".  
intros n m H. apply lt_succ_r. now apply lt_pred_le.
Qed.

Theorem le_pred_le_succ : forall n m, P n <= m <-> n <= S m.
Proof. try hammer_hook "NOrder" "NOrder.NOrderProp.le_pred_le_succ".  
intros n m; cases n.
rewrite pred_0. split; intro H; apply le_0_l.
intro n. rewrite pred_succ. apply succ_le_mono.
Qed.

End NOrderProp.

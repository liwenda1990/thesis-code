(* ========================================================================= *)
(* FIRST ORDER LOGIC SUBSTITUTIONS                                           *)
(* Copyright (c) 2001 Joe Hurd, distributed under the MIT license            *)

(* ========================================================================= *)

signature Subst =
sig

(* ------------------------------------------------------------------------- *)
(* A type of first order logic substitutions.                                *)
(* ------------------------------------------------------------------------- *)

type subst

(* ------------------------------------------------------------------------- *)
(* Basic operations.                                                         *)
(* ------------------------------------------------------------------------- *)

val empty : subst

val null : subst -> bool

val size : subst -> int

val peek : subst -> Term.var -> Term.term option

val insert : subst -> Term.var * Term.term -> subst

val singleton : Term.var * Term.term -> subst

val toList : subst -> (Term.var * Term.term) list

val fromList : (Term.var * Term.term) list -> subst

val foldl : (Term.var * Term.term * 'a -> 'a) -> 'a -> subst -> 'a

val foldr : (Term.var * Term.term * 'a -> 'a) -> 'a -> subst -> 'a

val pp : subst Print.pp

val toString : subst -> string

(* ------------------------------------------------------------------------- *)
(* Normalizing removes identity substitutions.                               *)
(* ------------------------------------------------------------------------- *)

val normalize : subst -> subst

(* ------------------------------------------------------------------------- *)
(* Applying a substitution to a first order logic term.                      *)
(* ------------------------------------------------------------------------- *)

val subst : subst -> Term.term -> Term.term

(* ------------------------------------------------------------------------- *)
(* Restricting a substitution to a smaller set of variables.                 *)
(* ------------------------------------------------------------------------- *)

val restrict : subst -> NameSet.set -> subst

val remove : subst -> NameSet.set -> subst

(* ------------------------------------------------------------------------- *)
(* Composing two substitutions so that the following identity holds:         *)
(*                                                                           *)
(* subst (compose sub1 sub2) tm = subst sub2 (subst sub1 tm)                 *)
(* ------------------------------------------------------------------------- *)

val compose : subst -> subst -> subst

(* ------------------------------------------------------------------------- *)
(* Creating the union of two compatible substitutions.                       *)
(* ------------------------------------------------------------------------- *)

val union : subst -> subst -> subst  (* raises Error *)

(* ------------------------------------------------------------------------- *)
(* Substitutions can be inverted iff they are renaming substitutions.        *)
(* ------------------------------------------------------------------------- *)

val invert : subst -> subst  (* raises Error *)

val isRenaming : subst -> bool

(* ------------------------------------------------------------------------- *)
(* Creating a substitution to freshen variables.                             *)
(* ------------------------------------------------------------------------- *)

val freshVars : NameSet.set -> subst

(* ------------------------------------------------------------------------- *)
(* Free variables.                                                           *)
(* ------------------------------------------------------------------------- *)

val redexes : subst -> NameSet.set

val residueFreeVars : subst -> NameSet.set

val freeVars : subst -> NameSet.set

(* ------------------------------------------------------------------------- *)
(* Functions.                                                                *)
(* ------------------------------------------------------------------------- *)

val functions : subst -> NameAritySet.set

(* ------------------------------------------------------------------------- *)
(* Matching for first order logic terms.                                     *)
(* ------------------------------------------------------------------------- *)

val match : subst -> Term.term -> Term.term -> subst  (* raises Error *)

(* ------------------------------------------------------------------------- *)
(* Unification for first order logic terms.                                  *)
(* ------------------------------------------------------------------------- *)

val unify : subst -> Term.term -> Term.term -> subst  (* raises Error *)

end

(* ========================================================================= *)
(* FIRST ORDER LOGIC TERMS                                                   *)
(* Copyright (c) 2001 Joe Hurd, distributed under the MIT license            *)

(* ========================================================================= *)

signature Term =
sig

(* ------------------------------------------------------------------------- *)
(* A type of first order logic terms.                                        *)
(* ------------------------------------------------------------------------- *)

type var = Name.name

type functionName = Name.name

type function = functionName * int

type const = functionName

datatype term =
    Var of var
  | Rat of Rat.rat
  | Fn of functionName * term list

(* ------------------------------------------------------------------------- *)
(* Constructors and destructors.                                             *)
(* ------------------------------------------------------------------------- *)

val isGround : term -> bool

val containsSkolemFunction : term -> bool

(* Variables *)

val destVar : term -> var

val isVar : term -> bool

val destRat : term -> Rat.rat

val isRat : term -> bool

val equalVar : var -> term -> bool

(* Functions *)

val destFn : term -> functionName * term list

val isFn : term -> bool

val fnName : term -> functionName

val fnArguments : term -> term list

val fnArity : term -> int

val fnFunction : term -> function

val functions : term -> NameAritySet.set

val functionNames : term -> NameSet.set

(* Constants *)

val mkConst : const -> term

val destConst : term -> const

val isConst : term -> bool

(* Binary functions *)

val mkBinop : functionName -> term * term -> term

val destBinop : functionName -> term -> term * term

val isBinop : functionName -> term -> bool

(* ------------------------------------------------------------------------- *)
(* The size of a term in symbols.                                            *)
(* ------------------------------------------------------------------------- *)

val symbols : term -> int

(* ------------------------------------------------------------------------- *)
(* A total comparison function for terms.                                    *)
(* ------------------------------------------------------------------------- *)

val compare : term * term -> order

val equal : term -> term -> bool

(* ------------------------------------------------------------------------- *)
(* Subterms.                                                                 *)
(* ------------------------------------------------------------------------- *)

type path = int list

val subterm : term -> path -> term

val subterms : term -> (path * term) list

val replace : term -> path * term -> term

val find : (term -> bool) -> term -> path option

val ppPath : path Print.pp

val pathToString : path -> string

(* ------------------------------------------------------------------------- *)
(* Free variables.                                                           *)
(* ------------------------------------------------------------------------- *)

val freeIn : var -> term -> bool

val freeVars : term -> NameSet.set

val freeVarsList : term list -> NameSet.set

val freeSkos : term -> NameSet.set

val freeSkosList : term list -> NameSet.set

(* ------------------------------------------------------------------------- *)
(* Fresh variables.                                                          *)
(* ------------------------------------------------------------------------- *)

val newVar : unit -> term

val newVars : int -> term list

val variantPrime : NameSet.set -> var -> var

val variantNum : NameSet.set -> var -> var

(* ------------------------------------------------------------------------- *)
(* Special support for terms with type annotations.                          *)
(* ------------------------------------------------------------------------- *)

val hasTypeFunctionName : functionName

val hasTypeFunction : function

val isTypedVar : term -> bool

val typedSymbols : term -> int

val nonVarTypedSubterms : term -> (path * term) list

(* ------------------------------------------------------------------------- *)
(* Special support for terms with an explicit function application operator. *)
(* ------------------------------------------------------------------------- *)

val appName : Name.name

val mkApp : term * term -> term

val destApp : term -> term * term

val isApp : term -> bool

val listMkApp : term * term list -> term

val stripApp : term -> term * term list

(* ------------------------------------------------------------------------- *)
(* Parsing and pretty printing.                                              *)
(* ------------------------------------------------------------------------- *)

(* Infix symbols *)

(*LCP:  modified parsing*)
val infixes : Print.infixes

val eval_Fn : functionName * term list -> term

(* The negation symbol *)

val negation : string ref

(* Binder symbols *)

val binders : string list ref

(* Pretty printing *)

val pp : term Print.pp

val toString : term -> string

(* Parsing *)

val fromString : string -> term

val iparser : ('a -> string) -> ('a Stream.stream -> term * 'a Stream.stream) ->
      'a Stream.stream -> term * 'a Stream.stream

val parse : term Parse.quotation -> term

(* ------------------------------------------------------------------------- *)
(* Hashing.                                                                  *)
(* ------------------------------------------------------------------------- *)

val hashw : term * word -> word

val hashwList : term list * word -> word

end

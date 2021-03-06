(* ========================================================================= *)
(* POLY/ML SPECIFIC FUNCTIONS                                                *)
(* Copyright (c) 2001 Joe Hurd, distributed under the MIT license            *)

(* ========================================================================= *)

structure Portable :> Portable =
struct

(* ------------------------------------------------------------------------- *)
(* The ML implementation.                                                    *)
(* ------------------------------------------------------------------------- *)

val ml = "polyml";

(* ------------------------------------------------------------------------- *)
(* Pointer equality using the run-time system.                               *)
(* ------------------------------------------------------------------------- *)

fun pointerEqual (x : 'a, y : 'a) = pointerEq(x,y);

(* ------------------------------------------------------------------------- *)
(* Timing function applications.                                             *)
(* ------------------------------------------------------------------------- *)

fun time f x =
    let
      fun p t =
          let
            val s = Time.fmt 3 t
          in
            case size (List.last (String.fields (fn x => x = #".") s)) of
              3 => s
            | 2 => s ^ "0"
            | 1 => s ^ "00"
            | _ => raise Fail "Portable.time"
          end

      val c = Timer.startCPUTimer ()

      val r = Timer.startRealTimer ()

      fun pt () =
          let
            val {usr,sys} = Timer.checkCPUTimer c
            val real = Timer.checkRealTimer r
          in
            print
              ("User: " ^ p usr ^ "  System: " ^ p sys ^
               "  Real: " ^ p real ^ "\n")
          end

      val y = f x handle e => (pt (); raise e)

      val () = pt ()
    in
      y
    end;

(* ------------------------------------------------------------------------- *)
(* Generating random values.                                                 *)
(* ------------------------------------------------------------------------- *)

val randomWord = Random.nextWord;

val randomBool = Random.nextBool;

val randomInt = Random.nextInt;

val randomReal = Random.nextReal;

end

(* ------------------------------------------------------------------------- *)
(* Quotations a la Moscow ML.                                                *)
(* ------------------------------------------------------------------------- *)

datatype 'a frag = QUOTE of string | ANTIQUOTE of 'a;

(* SML/NJ Emulation *)
structure Unsafe =
  struct
  structure Vector = Vector and CharVector = CharVector
  end;

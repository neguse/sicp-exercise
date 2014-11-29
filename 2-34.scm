#lang racket

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))
; 1 + 3 * 2 + 5 * 2^3 + 1 * 2^5
; = 1 + 6 + 40 + 32
; = 79
; 適当に書いてみたらあってる…なんで…

; えーと、accumulateってcarに対してopを適用して、次cdrする…と思ってたんだけど、
; cdrの方が再帰になってるから、末尾の要素から順番に適用されるんですね。
; Haskellちょっとやった時にfoldlとかfoldrとか出てきたと思うんだけど、
; このaccumulateはfoldlじゃなくてfoldrなんですね。
; なので期待した動作になる、と。
; ははあ

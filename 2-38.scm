#lang racket

(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (fold-right op initial (cdr sequence)))))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(fold-right / 1 (list 1 2 3))
; 1/6 <- まちがい

(fold-left / 1 (list 1 2 3))
; 1/6

(fold-right list '() (list 1 2 3))
; (3 2 1) <- まちがい

(fold-left list '() (list 1 2 3))
; (1 2 3) <- まちがい

; たぶん演算子が可換かどうかは関係なく、
; 評価順に依存するかどうかなんじゃないか。

; …ちがった。可換じゃないと駄目、って感じっぽい。
; しかも後のやつはconsじゃなくてlistだし…だめだめでした。

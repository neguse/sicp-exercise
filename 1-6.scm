#lang racket
; new-ifは特殊形式じゃないので、then-clauseもelse-clauseも
; 無条件に評価してしまうので、
; 今回のような条件分岐をつかって再帰の停止条件を実装しているプログラムは
; 無限再帰になってしまう。

; ためしてみる


(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (square x)
  (* x x))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt-iter guess x)
	(new-if (good-enough? guess x)
		guess
		(sqrt-iter (improve guess x)
							 x)))

(define (improve guess x)
	(average guess (/ x guess)))

(define (average x y)
	(/ (+ x y) 2))

(define (sqrt x)
	  (sqrt-iter 1.0 x))

(sqrt 9)

; 再帰が止まらなかった

; 余談だが、キャラクタの名前は英語版Wikipediaに説明がある
; http://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs#Characters


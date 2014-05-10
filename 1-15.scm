#lang racket

(define counter 0)

(define (cube x) (* x x x))

(define (p x)
	(set! counter (+ counter 1))
	(- (* 3 x) (* 4 (cube x))))

(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))

(sine 12.15)

counter
; a. 5でした。

; b.
; スペースは、再帰の深さなんだけど、
; この問題だと1ステップでaが1/3になっていって、
; aが0.1以下になった時点で止まるので、
; 止まるまでのステップ数をnとした時、a * (1/3) ^ n < 0.1
; a * (1/3) ^ n は対数関数的に減少していくので、logでしょうか。
; θ(log(n))?であってる?
;
; ステップ数は、今回の場合p->sine->p->sine->...という繰り返しの再帰なので、
; スペースと変わらず、θ(log(n))なんですね。たぶん。


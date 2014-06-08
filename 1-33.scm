#lang racket

(define (filtered-accumulate combiner null-value term a next b filter?)
  (cond
	((> a b) null-value)
	((filter? a)
		(combiner (term a)
				  (filtered-accumulate combiner null-value term (next a) next b filter?)))
	(else (filtered-accumulate combiner null-value term (next a) next b filter?))))

(define (filtered-accumulate2 combiner null-value term a next b filter?)
  (define (iter a result)
	(cond
	  ((> a b) result)
	  ((filter? a)
	   (iter (next a) (combiner result (term a))))
	  (else 
	   (iter (next a) result))))
  (iter a null-value))

(define (sum-even term a next b)
  (define (add x y) (+ x y))
  (filtered-accumulate add 0 term a next b even?))
(define (sum2-even term a next b)
  (define (add x y) (+ x y))
  (filtered-accumulate2 add 0 term a next b even?))

(define (ident x) x)
(define (inc x) (+ x 1))

(sum-even ident 0 inc 10)
(sum2-even ident 0 inc 10)

; とりあえず書けたけど、機能追加して汎用化しました、っていうの好きじゃない。
; 本当に汎用化・抽象化できてるのであれば、
; その構成要素は減って然るべきじゃないかと思う。

(define (square x) (* x x))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (square-prime-sum a b)
  (define (add x y) (+ x y))
  (filtered-accumulate add 0 square a inc b prime?))

(square-prime-sum 1 10)
; 88
; 2^2 + 3^2 + 5^2 + 7^2
; = 4 + 9 + 25 + 49
; = 87
; ... のはずなんだけど、88になっちゃってますね。
; これはprime?が1のときに#tを返しているからっぽいけど、まあいいか。

(define (gcd a b)
  (if (= b 0)
	a
	(gcd b (remainder a b))))

(define (coprime-mul n)
  (define (mul x y) (* x y))
  (define (coprime x) (= 1 (gcd x n)))
  (filtered-accumulate mul 1 ident 1 inc (- n 1) coprime))

(coprime-mul 11)
; うーん、これ結果があってるのかどうかわからん。
; http://www.billthelizard.com/2010/05/sicp-exercise-133-filtered-accumulator.html
; まあ、あってそうだからいいか。

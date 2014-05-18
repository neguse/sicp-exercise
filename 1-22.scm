#lang racket
; とりあえずこれ問題文のままだと動かなかった
; http://stackoverflow.com/questions/2195105/is-there-an-equivalent-to-lisps-runtime-primitive-in-scheme
;

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

(define (timed-prime-test n)
  (start-prime-test n (current-inexact-milliseconds)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime n (- (current-inexact-milliseconds) start-time))
			#f)) ; <- ここelse節が必要だった。とりあえずnilっぽい値で。

(define (report-prime n elapsed-time)
  (display n)
  (display " *** ")
  (display elapsed-time)
  (newline)
	#t)

; うーん、問題文には「指定範囲の」って書いてあるけど、
; これ指定個数ヒットしたら終わるようにした方がいいんじゃないかな
(define (search-for-primes start step count)
	(if (= count 0)
		"done"
		(if (timed-prime-test start)
			(search-for-primes (+ start step) step (- count 1))
			(search-for-primes (+ start step) step count))))

(search-for-primes 1000 1 3)
; 1009 *** 0.0009765625
; 1013 *** 0.0009765625
; 1019 *** 0.0009765625
(search-for-primes 1000 -1 3)
; 997 *** 0.0009765625
; 991 *** 0.001220703125
; 983 *** 0.0009765625
(search-for-primes 10000 1 3)
; 10007 *** 0.003173828125
; 10009 *** 0.003173828125
; 10037 *** 0.003173828125
(search-for-primes 10000 -1 3)
; 9973 *** 0.0029296875
; 9967 *** 0.00390625
; 9949 *** 0.0029296875
(search-for-primes 100000 1 3)
; 100003 *** 0.009765625
; 100019 *** 0.009033203125
; 100043 *** 0.010986328125
(search-for-primes 100000 -1 3)
; 99991 *** 0.009033203125
; 99989 *** 0.010986328125
; 99971 *** 0.010986328125
(search-for-primes 1000000 1 3)
; 1000003 *** 0.033935546875
; 1000033 *** 0.027099609375
; 1000037 *** 0.027099609375
(search-for-primes 1000000 -1 3)
; 999983 *** 0.028076171875
; 999979 *** 0.043212890625
; 999961 *** 0.027099609375

; だいたい3倍程度になってるから、おｋじゃないでしょうか。

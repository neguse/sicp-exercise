#lang racket

(define (next n)
	(if (= n 2) 3
		(+ n 2)))

(define (square x) (* x x))

(define (smallest-divisor n)
  (find-divisor n 2))


(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))


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
; 1009 *** 0.0
; 1013 *** 0.0009765625
; 1019 *** 0.0
(search-for-primes 1000 -1 3)
; 997 *** 0.0
; 991 *** 0.0
; 983 *** 0.0009765625
(search-for-primes 10000 1 3)
; 10007 *** 0.0009765625
; 10009 *** 0.0009765625
; 10037 *** 0.0009765625
(search-for-primes 10000 -1 3)
; 9973 *** 0.001953125
; 9967 *** 0.0009765625
; 9949 *** 0.002197265625
(search-for-primes 100000 1 3)
; 100003 *** 0.0048828125
; 100019 *** 0.00390625
; 100043 *** 0.00390625
(search-for-primes 100000 -1 3)
; 99991 *** 0.005126953125
; 99989 *** 0.00390625
; 99971 *** 0.00390625
(search-for-primes 1000000 1 3)
; 1000003 *** 0.013916015625
; 1000033 *** 0.013916015625
; 1000037 *** 0.01416015625
(search-for-primes 1000000 -1 3)
; 999983 *** 0.013916015625
; 999979 *** 0.01416015625
; 999961 *** 0.013916015625

; 上の方は0とかになっててよくわからんけど、
; 1000000のやつはだいたい2倍ぐらい早くなってる気がする。
; 測定誤差とかif文の分岐、next関数呼び出しの分がのっかるから
; 完全に2倍になるわけじゃないですね。
; …って書いてあった。
; http://www.billthelizard.com/2010/02/sicp-exercise-123-improved-prime-test.html


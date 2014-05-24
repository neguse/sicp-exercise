#lang racket
; fast-prime?の引数timesって何を指定すればいいのかよくわからんですね。
; http://www.billthelizard.com/2010/02/sicp-exercise-124-fermat-test.html
; ここの人は100でやってるっぽいので、とりあえず100にしてみますか。


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
  (if (fast-prime-100? n)
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

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))      

(define (fermat-test n)
	(define (try-it a)
		(= (expmod a n n) a))
	(try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
	(cond ((= times 0) true)
				((fermat-test n) (fast-prime? n (- times 1)))
				(else #f)))

(define (fast-prime-100? n)
	(fast-prime? n 10))

(search-for-primes 1000 1 3)
; 1009 *** 0.2919921875
; 1013 *** 0.141845703125
; 1019 *** 0.14794921875
(search-for-primes 1000 -1 3)
; 997 *** 0.13720703125
; 991 *** 0.14794921875
; 983 *** 0.14306640625
(search-for-primes 10000 1 3)
; 10007 *** 0.171142578125
; 10009 *** 0.169921875
; 10037 *** 0.172119140625
(search-for-primes 10000 -1 3)
; 9973 *** 0.175048828125
; 9967 *** 0.180908203125
; 9949 *** 0.18017578125
(search-for-primes 100000 1 3)
; 100003 *** 0.2021484375
; 100019 *** 0.202880859375
; 100043 *** 0.20703125
(search-for-primes 100000 -1 3)
; 99991 *** 0.2060546875
; 99989 *** 0.300048828125
; 99971 *** 0.197021484375
(search-for-primes 1000000 1 3)
; 1000003 *** 0.225830078125
; 1000033 *** 0.22607421875
; 1000037 *** 0.625
(search-for-primes 1000000 -1 3)
; 999983 *** 0.23388671875
; 999979 *** 0.22998046875
; 999961 *** 0.22607421875

; なんか10~20倍ぐらい時間かかってるんですけど
; どこがfastなんですかね…

; 1e8ぐらいでやってみたら確かに
; fast-prime?の方が安定して早かった。
; これがθ(log n)のちからか！

; nが1e6ぐらいだとまだ1-22の方が
; 早そうだったんだけど、
; 問題文の口ぶりからするに、
; 多分1e6ぐらいでも逆転しそうな気がする。
; これは処理系が最適化がんばってるとか
; そういう部分で時代が変わったということなんでしょうか
; それとも時間のはかりかた間違ってるとか？

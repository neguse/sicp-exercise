#lang racket

(define (interleave s1 s2)
  (if (stream-empty? s1)
	s2
	(stream-cons (stream-first s1)
				 (interleave s2 (stream-rest s1)))))

(define (pairs s t)
  (stream-cons
	(list (stream-first s) (stream-first t))
	(interleave
	  (stream-map (lambda (x) (list (stream-first s) x))
				  (stream-rest t))
	  (pairs (stream-rest s) (stream-rest t)))))

(define (integers-starting-from n)
  (stream-cons n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define pii (pairs integers integers))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

(define (stream-take s i)
  (if (= i 0)
	empty-stream
	(stream-cons (stream-first s)
				 (stream-take (stream-rest s) (- i 1)))))

(display-stream (stream-take pii 100))
; こんな感じで観察してみる

; (1 2)の2個次に(1 3)が来てるので、
; (1 100)は約200個次なんだろうなぁ。

; (1 2)...2nd
; (2 3)...5th
; (3 4)...11th
; (4 5)...23rd
; ...これはThabit numberというっぽい。
; https://en.wikipedia.org/wiki/Thabit_number

; (1 1)...1st
; (2 2)...3rd
; (3 3)...7th
; (4 4)...15th
; これはn^2-1ですね。


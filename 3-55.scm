#lang racket

(define (partial-sums s)
  (cons-stream (stream-car s)
			   (add-streams s (stream-cdr s))))

; こんなんでどうでしょうか。
; …だめそう。

(define (partial-sums s)
  (cons-stream (stream-car s)
			   (add-streams (partial-sums s) (stream-cdr s))))

; こうらしい。
; 確かに、sそのままだと1個前との和だけになってしまって累積的な和にならない。
; partial-sumsで再帰してないとダメですね。


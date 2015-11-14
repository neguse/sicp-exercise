#lang racket

; a.

; こうして
(define (div-streams s1 s2)
  (stream-map / s1 s2))

; こうじゃ
(define (integrate-series s)
  (div-streams s integers))

; b.

(define minus
  (cons-stream -1 minus))

(define cosine-series
  (cons-stream 1 (mul-streams (integrate-series sine-series) minus)))
(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))
; こんなんでいいのか?
